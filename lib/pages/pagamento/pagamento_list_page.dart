import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../mvvm/viewmodels/pagamento_viewmodel.dart';
import '../../models/pagamento.dart';
import 'pagamento_form_page.dart';

/// Tela que lista todas as formas de pagamento cadastradas.
class PagamentoListPage extends StatefulWidget {
  const PagamentoListPage({super.key});

  @override
  State<PagamentoListPage> createState() => _PagamentoListPageState();
}

class _PagamentoListPageState extends State<PagamentoListPage> {
  @override
  void initState() {
    super.initState();

    // Carrega os pagamentos assim que o widget é montado.
    Future.microtask(
      () => Provider.of<PagamentoViewModel>(
        context,
        listen: false, // Não precisa ouvir mudanças aqui
      ).carregarPagamentos(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtém o ViewModel e fica escutando mudanças automáticas
    final viewModel = Provider.of<PagamentoViewModel>(context);

    // Cria uma cópia da lista original e ordena alfabeticamente
    final pagamentosOrdenados = [...viewModel.pagamentos];
    pagamentosOrdenados.sort(
      (a, b) => a.tipo.toLowerCase().compareTo(b.tipo.toLowerCase()),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Formas de Pagamento"),
        centerTitle: true,
      ),

      body: viewModel.carregando

          // Exibe indicador de carregamento enquanto busca os dados.
          ? const Center(child: CircularProgressIndicator())

          // Caso não existam formas de pagamento cadastradas.
          : pagamentosOrdenados.isEmpty
              ? const Center(
                  child: Text(
                    "Nenhuma forma de pagamento cadastrada.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )

              // Lista de pagamentos quando há dados disponíveis
              : ListView.builder(
                  itemCount: pagamentosOrdenados.length,
                  itemBuilder: (context, index) {
                    final Pagamento pagamento = pagamentosOrdenados[index];

                    return Card(
                      color: const Color.fromARGB(255, 253, 212, 226),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),

                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.pink.shade300,
                          child: const Icon(Icons.payment, color: Colors.white),
                        ),

                        // Nome do tipo de pagamento
                        title: Text(
                          pagamento.tipo,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        // Botão com menu para editar ou excluir
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'edit') {
                              // Abre a tela de edição com os dados
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PagamentoFormPage(pagamento: pagamento),
                                ),
                              );
                            } else if (value == 'delete') {
                              // Remove o pagamento selecionado
                              await viewModel.removerPagamento(pagamento.id!);
                            }
                          },

                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'edit', child: Text('Editar')),
                            PopupMenuItem(value: 'delete', child: Text('Excluir')),
                          ],
                        ),
                      ),
                    );
                  },
                ),

      // Botão flutuante para adicionar uma nova forma de pagamento
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PagamentoFormPage()),
          );
        },
        backgroundColor: Colors.pink.shade300,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
