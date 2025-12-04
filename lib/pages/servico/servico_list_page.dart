import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../mvvm/viewmodels/servico_viewmodel.dart';
import '../../models/servico.dart';
import 'servico_form_page.dart';

/// TELA: Lista de Serviços
class ServicoListPage extends StatefulWidget {
  const ServicoListPage({super.key});

  @override
  State<ServicoListPage> createState() => _ServicoListPageState();
}

class _ServicoListPageState extends State<ServicoListPage> {
  @override
  void initState() {
    super.initState();

    // Carrega os serviços assim que a tela é inicializada.
    Future.microtask(
      () => Provider.of<ServicoViewModel>(
        context,
        listen: false,
      ).carregarServicos(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Acessa o ViewModel para obter a lista de serviços
    final viewModel = Provider.of<ServicoViewModel>(context);

    // Cria uma cópia da lista original e ordena alfabeticamente
    final servicosOrdenados = [...viewModel.servicos];
    servicosOrdenados.sort(
      (a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()),
    );

    return Scaffold(
      // Barra superior da aplicação
      appBar: AppBar(
        title: const Text("Serviços"),
        centerTitle: true,
      ),

      // Corpo da tela
      body: viewModel.carregando
          // Exibe um loading enquanto carrega os dados
          ? const Center(child: CircularProgressIndicator())

          // Caso a lista esteja vazia, mostra mensagem amigável
          : servicosOrdenados.isEmpty
              ? const Center(
                  child: Text(
                    "Nenhum serviço cadastrado.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )

              // Caso tenha serviços, lista tudo
              : ListView.builder(
                  itemCount: servicosOrdenados.length,
                  itemBuilder: (context, index) {
                    final Servico servico = servicosOrdenados[index];

                    return Card(
                      color: const Color.fromARGB(255, 253, 212, 226),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),

                      child: ListTile(
                        // Ícone à esquerda
                        leading: CircleAvatar(
                          backgroundColor: Colors.pink.shade300,
                          child: const Icon(Icons.build, color: Colors.white),
                        ),

                        // Nome do serviço em destaque
                        title: Text(
                          servico.nome,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        // Valor do serviço como subtítulo
                        subtitle: Text(
                          'Valor: R\$ ${servico.valor.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.grey),
                        ),

                        // Botão de opções (editar / excluir)
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'edit') {
                              // Abre o formulário preenchido para edição
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ServicoFormPage(servico: servico),
                                ),
                              );
                            } else if (value == 'delete') {
                              // Remove o serviço pelo ID
                              await viewModel.removerServico(servico.id!);
                            }
                          },

                          // Opções do menu
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                                value: 'edit', child: Text('Editar')),
                            PopupMenuItem(
                                value: 'delete', child: Text('Excluir')),
                          ],
                        ),
                      ),
                    );
                  },
                ),

      // Botão flutuante para adicionar novo serviço
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Abre o formulário para criar novo serviço
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ServicoFormPage()),
          );
        },
        backgroundColor: Colors.pink.shade300,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
