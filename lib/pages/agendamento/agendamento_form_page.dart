import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/agendamento.dart';
import '../../models/cliente.dart';
import '../../models/funcionario.dart';
import '../../models/servico.dart';
import '../../models/pagamento.dart';
import '../../mvvm/viewmodels/agendamento_viewmodel.dart';
import '../../mvvm/viewmodels/cliente_viewmodel.dart';
import '../../mvvm/viewmodels/funcionario_viewmodel.dart';
import '../../mvvm/viewmodels/servico_viewmodel.dart';
import '../../mvvm/viewmodels/pagamento_viewmodel.dart';
import '../cliente/cliente_form_page.dart';
import '../servico/servico_form_page.dart';
import '../pagamento/pagamento_form_page.dart';

/// Página de formulário para adicionar ou editar um agendamento.
class AgendamentoFormPage extends StatefulWidget {
  final Agendamento? agendamento;
  const AgendamentoFormPage({super.key, this.agendamento});

  @override
  State<AgendamentoFormPage> createState() => _AgendamentoFormPageState();
}

class _AgendamentoFormPageState extends State<AgendamentoFormPage> {
  // Chave global do formulário para validação
  final _formKey = GlobalKey<FormState>();

  // Controllers dos campos de texto
  final _dataCtrl = TextEditingController();
  final _horaCtrl = TextEditingController();
  final _valorCtrl = TextEditingController();

  // IDs selecionados nos dropdowns
  int? _idCliente;
  int? _idFuncionario;
  int? _idServico;
  int? _idPagamento;

  // Switches
  bool _pago = false;
  bool _realizado = false;

  @override
  void initState() {
    super.initState();

    // Carrega os dados de forma assíncrona logo ao abrir a tela
    Future.microtask(() async {
      final clientesVm = Provider.of<ClienteViewModel>(context, listen: false);
      final funcsVm = Provider.of<FuncionarioViewModel>(context, listen: false);
      final servicosVm = Provider.of<ServicoViewModel>(context, listen: false);
      final pagVm = Provider.of<PagamentoViewModel>(context, listen: false);

      // Só carrega se estiver vazio 
      if (clientesVm.clientes.isEmpty) await clientesVm.carregarClientes();
      if (funcsVm.funcionarios.isEmpty) await funcsVm.carregarFuncionarios();
      if (servicosVm.servicos.isEmpty) await servicosVm.carregarServicos();
      if (pagVm.pagamentos.isEmpty) await pagVm.carregarPagamentos();
    });

    // Se está editando um agendamento, preenche os campos com os dados existentes
    if (widget.agendamento != null) {
      final ag = widget.agendamento!;

      _idCliente = ag.idCliente;
      _idFuncionario = ag.idFuncionario;
      _idServico = ag.idServico;
      _idPagamento = ag.idPagamento;

      _dataCtrl.text = ag.data;
      _horaCtrl.text = ag.hora;

      // Valor vem como double → converte para texto com 2 decimais
      _valorCtrl.text = ag.valorTotal.toStringAsFixed(2);

      _pago = ag.pago;
      _realizado = ag.realizado;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ViewModels usados
    final vmAg = Provider.of<AgendamentoViewModel>(context, listen: false);

    final clientesVm = Provider.of<ClienteViewModel>(context);
    final funcsVm = Provider.of<FuncionarioViewModel>(context);
    final servicosVm = Provider.of<ServicoViewModel>(context);
    final pagVm = Provider.of<PagamentoViewModel>(context);

    // Se algum dado ainda está carregando, exibe loading
    if (clientesVm.carregando ||
        funcsVm.carregando ||
        servicosVm.carregando ||
        pagVm.carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Verifica se está editando ou criando novo
    final editando = widget.agendamento != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? "Editar Agendamento" : "Novo Agendamento"),
        centerTitle: true,
        backgroundColor: Colors.pink.shade400,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: Colors.grey.shade100,
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    // ---------------------- CLIENTE ----------------------
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _idCliente,
                            decoration: const InputDecoration(
                              labelText: "Cliente",
                            ),

                            // Lista de clientes vinda do Provider
                            items: clientesVm.clientes
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c.id,
                                    child: Text(c.nome),
                                  ),
                                )
                                .toList(),

                            onChanged: (v) => setState(() => _idCliente = v),

                            validator: (v) =>
                                v == null ? "Selecione um cliente" : null,
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Botão para cadastrar novo cliente
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink.shade400,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text("Novo"),
                          onPressed: () async {
                            // Abre a tela de cliente
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ClienteFormPage(),
                              ),
                            );

                            // Recarrega a lista após cadastrar novo cliente
                            await clientesVm.carregarClientes();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // ---------------------- FUNCIONÁRIO ----------------------
                    DropdownButtonFormField<int>(
                      value: _idFuncionario,
                      decoration: const InputDecoration(
                        labelText: "Funcionário",
                      ),
                      items: funcsVm.funcionarios
                          .map(
                            (f) => DropdownMenuItem(
                              value: f.id,
                              child: Text(f.nome),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _idFuncionario = v),
                      validator: (v) =>
                          v == null ? "Selecione um funcionário" : null,
                    ),

                    const SizedBox(height: 8),

                    // ---------------------- SERVIÇO ----------------------
                    DropdownButtonFormField<int>(
                      value: _idServico,
                      decoration: const InputDecoration(labelText: "Serviço"),
                      items: servicosVm.servicos
                          .map(
                            (s) => DropdownMenuItem(
                              value: s.id,
                              child: Text("${s.nome}"),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        setState(() {
                          _idServico = v;

                          // Preenche o campo Valor Total automaticamente
                          final servico = servicosVm.servicos.firstWhere(
                            (s) => s.id == v,
                            orElse: () => Servico(id: 0, nome: '', valor: 0.0),
                          );

                          _valorCtrl.text = servico.valor.toStringAsFixed(2);
                        });
                      },
                      validator: (v) =>
                          v == null ? "Selecione um serviço" : null,
                    ),

                    const SizedBox(height: 8),

                    // ---------------------- VALOR ----------------------
                    TextFormField(
                      controller: _valorCtrl,
                      readOnly: true, // Sempre preenchido automaticamente
                      decoration: const InputDecoration(
                        labelText: "Valor Total",
                        prefixText: "R\$ ",
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ---------------------- PAGAMENTO ----------------------
                    DropdownButtonFormField<int>(
                      value: _idPagamento,
                      decoration: const InputDecoration(
                        labelText: "Forma de Pagamento",
                      ),
                      items: pagVm.pagamentos
                          .map(
                            (p) => DropdownMenuItem(
                              value: p.id,
                              child: Text(p.tipo),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _idPagamento = v),
                      validator: (v) =>
                          v == null ? "Selecione a forma de pagamento" : null,
                    ),

                    const SizedBox(height: 8),

                    // ---------------------- DATA ----------------------
                    TextFormField(
                      controller: _dataCtrl,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "Data",
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        final hoje = DateTime.now();

                        // Abre calendário
                        final data = await showDatePicker(
                          context: context,
                          initialDate: hoje,
                          firstDate: hoje, // não permite datas anteriores
                          lastDate: DateTime(2100),
                          locale: const Locale('pt', 'BR'),
                        );

                        if (data != null) {
                          _dataCtrl.text = DateFormat(
                            'dd/MM/yyyy',
                          ).format(data);
                        }
                      },
                      validator: (v) =>
                          v == null || v.isEmpty ? "Informe a data" : null,
                    ),

                    const SizedBox(height: 8),

                    // ---------------------- HORA ----------------------
                    TextFormField(
                      controller: _horaCtrl,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "Hora",
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      onTap: () async {
                        // Exige que a data seja escolhida primeiro
                        if (_dataCtrl.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Selecione a data primeiro"),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }

                        final hora = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (hora != null) {
                          _horaCtrl.text =
                              "${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}";
                        }
                      },
                      validator: (v) =>
                          v == null || v.isEmpty ? "Informe a hora" : null,
                    ),

                    const SizedBox(height: 8),

                    // ---------------------- SWITCHES ----------------------
                    SwitchListTile(
                      title: const Text("Pago"),
                      value: _pago,
                      onChanged: (v) => setState(() => _pago = v),
                    ),
                    SwitchListTile(
                      title: const Text("Realizado"),
                      value: _realizado,
                      onChanged: (v) => setState(() => _realizado = v),
                    ),

                    const SizedBox(height: 16),

                    // ---------------------- BOTÃO SALVAR ----------------------
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink.shade400,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      icon: const Icon(Icons.save),
                      label: Text(
                        editando
                            ? "Salvar Alterações"
                            : "Cadastrar Agendamento",
                      ),

                      onPressed: () async {
                        // Valida os campos
                        if (_formKey.currentState!.validate()) {
                          // Monta o objeto de agendamento
                          final ag = Agendamento(
                            id: widget.agendamento?.id,
                            idCliente: _idCliente!,
                            idFuncionario: _idFuncionario!,
                            idServico: _idServico!,
                            idPagamento: _idPagamento!,
                            data: _dataCtrl.text,
                            hora: _horaCtrl.text,
                            valorTotal: double.tryParse(_valorCtrl.text) ?? 0.0,
                            pago: _pago,
                            realizado: _realizado,
                          );

                          // Decide entre adicionar ou editar
                          if (editando) {
                            await vmAg.atualizarAgendamento(ag);
                          } else {
                            await vmAg.adicionarAgendamento(ag);
                          }

                          // Fecha a tela após salvar
                          if (context.mounted) Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}