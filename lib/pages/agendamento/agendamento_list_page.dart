import 'package:agendamento/models/pagamento.dart';
import 'package:agendamento/pages/pagamento/pagamento_list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../mvvm/viewmodels/agendamento_viewmodel.dart';
import '../../mvvm/viewmodels/cliente_viewmodel.dart';
import '../../mvvm/viewmodels/funcionario_viewmodel.dart';
import '../../mvvm/viewmodels/servico_viewmodel.dart';
import '../../mvvm/viewmodels/pagamento_viewmodel.dart';
import '../../models/agendamento.dart';
import 'agendamento_form_page.dart';
import 'package:intl/intl.dart';

/// PÁGINA DE LISTAGEM DOS AGENDAMENTOS
class AgendamentoListPage extends StatefulWidget {
  const AgendamentoListPage({super.key});

  @override
  State<AgendamentoListPage> createState() => _AgendamentoListPageState();
}

class _AgendamentoListPageState extends State<AgendamentoListPage> {

  @override
  void initState() {
    super.initState();

    // Assim que a tela abre, carrega a lista de agendamentos.
    Future.microtask(() {
      Provider.of<AgendamentoViewModel>(context, listen: false)
          .carregarAgendamentos();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Pega todos os ViewModels da árvore
    final agVm = Provider.of<AgendamentoViewModel>(context);
    final cliVm = Provider.of<ClienteViewModel>(context);
    final funcVm = Provider.of<FuncionarioViewModel>(context);
    final servVm = Provider.of<ServicoViewModel>(context);
    final pagVm = Provider.of<PagamentoViewModel>(context);

    // MAPAS DE CONSULTA RÁPIDA
    // Convertem ID → Nome (Cliente, Funcionário, Serviço, Pagamento)
    final clienteMap = {for (var c in cliVm.clientes) c.id!: c.nome};
    final funcionarioMap = {for (var f in funcVm.funcionarios) f.id!: f.nome};
    final servicoMap = {for (var s in servVm.servicos) s.id!: s.nome};
    final pagamentoMap = {for (var p in pagVm.pagamentos) p.id!: p.tipo};

    return Scaffold(
      appBar: AppBar(
        title: const Text("Agendamentos"),
        centerTitle: true,
      ),

      // EXIBE O LOADING ENQUANTO CARREGA
      body: agVm.carregando
          ? const Center(child: CircularProgressIndicator())

          // SE NÃO HÁ AGENDAMENTOS → MENSAGEM
          : agVm.agendamentos.isEmpty
              ? const Center(
                  child: Text(
                    "Nenhum agendamento registrado.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )

              // LISTA OS AGENDAMENTOS
              : () {

                  // Função p/ converter datas flexíveis
                  DateTime? _parseDate(String? s) {
                    if (s == null) return null;
                    try {
                      return DateTime.parse(s); // yyyy-MM-dd
                    } catch (_) {
                      try {
                        return DateFormat('dd/MM/yyyy').parseStrict(s);
                      } catch (_) {
                        return null;
                      }
                    }
                  }

                  // Converte "HH:mm" para minutos totais
                  int _minutesFromTime(String? t) {
                    if (t == null || t.isEmpty) return 0;
                    try {
                      final p = t.split(':');
                      return (int.parse(p[0]) * 60) + int.parse(p[1]);
                    } catch (_) {
                      return 0;
                    }
                  }

                  // Cria cópia da lista e ordena
                  final lista = [...agVm.agendamentos];

                  lista.sort((a, b) {
                    final da = _parseDate(a.data) ??
                        DateTime.fromMillisecondsSinceEpoch(0);
                    final db = _parseDate(b.data) ??
                        DateTime.fromMillisecondsSinceEpoch(0);

                    // Ordena DATA → mais nova primeiro
                    final cmp = db.compareTo(da);
                    if (cmp != 0) return cmp;

                    // Ordena HORÁRIO → do menor para o maior
                    return _minutesFromTime(a.hora)
                        .compareTo(_minutesFromTime(b.hora));
                  });

                  // LISTVIEW FINAL
                  return ListView.builder(
                    itemCount: lista.length,
                    itemBuilder: (context, index) {
                      final Agendamento ag = lista[index];

                      // Recupera nomes
                      final clienteNome = clienteMap[ag.idCliente] ?? 'N/A';
                      final funcionarioNome =
                          funcionarioMap[ag.idFuncionario] ?? 'N/A';
                      final servicoNome = servicoMap[ag.idServico] ?? 'N/A';
                      final pagamentoTipo =
                          pagamentoMap[ag.idPagamento] ?? 'N/A';

                      return Card(
                        color: const Color.fromARGB(255, 253, 212, 226),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 350),

                          child: ListTile(

                            // ÍCONE AO LADO DO AGENDAMENTO
                            leading: CircleAvatar(
                              backgroundColor: ag.realizado
                                  ? Colors.green.shade400
                                  : Colors.pink.shade300,
                              child: Icon(
                                ag.realizado
                                    ? Icons.check_circle
                                    : Icons.calendar_today,
                                color: Colors.white,
                              ),
                            ),

                            // TÍTULO → Data + Hora
                            title: Text(
                              "${ag.data} - ${ag.hora}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),

                            // SUBTÍTULO → Informações completas
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Cliente: $clienteNome",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                Text("Funcionário: $funcionarioNome",
                                    style: const TextStyle(fontSize: 16)),
                                Text("Serviço: $servicoNome",
                                    style: const TextStyle(fontSize: 16)),
                                Text(
                                  "Valor: R\$ ${ag.valorTotal.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.green.shade600,
                                  ),
                                ),

                                // DROPDOWN DE PAGAMENTO
                                Wrap(
                                  spacing: 8,
                                  children: [
                                    const Text("Pagamento:"),
                                    DropdownButton<int>(
                                      value: ag.idPagamento,
                                      items: pagVm.pagamentos
                                          .map(
                                            (p) => DropdownMenuItem(
                                              value: p.id,
                                              child: Text(p.tipo),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) async {
                                        if (value == null) return;

                                        // Atualiza apenas o pagamento
                                        await agVm.atualizarAgendamento(
                                          ag.copyWith(idPagamento: value),
                                        );

                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),

                                // SWITCH PAGO
                                SwitchListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text("Pago"),
                                  value: ag.pago,
                                  onChanged: (v) async {
                                    await agVm.atualizarAgendamento(
                                      ag.copyWith(pago: v),
                                    );
                                    setState(() {});
                                  },
                                ),

                                // SWITCH REALIZADO
                                SwitchListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text("Realizado"),
                                  value: ag.realizado,
                                  onChanged: (v) async {
                                    await agVm.atualizarAgendamento(
                                      ag.copyWith(realizado: v),
                                    );
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),

                            isThreeLine: true,

                            // MENU LATERAL (EDITAR / EXCLUIR)
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) async {
                                if (value == 'edit') {
                                  // Abre o formulário em modo edição
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          AgendamentoFormPage(
                                              agendamento: ag),
                                    ),
                                  );

                                  // Recarrega ao voltar
                                  await agVm.carregarAgendamentos();
                                } else if (value == 'delete') {
                                  await agVm.removerAgendamento(ag.id!);
                                }
                              },
                              itemBuilder: (_) => const [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Editar'),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Excluir'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }(),

      // BOTÃO DE NOVO AGENDAMENTO
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink.shade300,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AgendamentoFormPage(),
            ),
          );

          // Atualiza ao voltar
          await agVm.carregarAgendamentos();
        },
      ),
    );
  }
}
