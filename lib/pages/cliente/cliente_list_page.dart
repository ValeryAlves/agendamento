import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../mvvm/viewmodels/cliente_viewmodel.dart';
import '../../models/cliente.dart';
import 'cliente_form_page.dart';

/// Tela que lista todos os clientes cadastrados.
class ClienteListPage extends StatefulWidget {
  const ClienteListPage({super.key});

  @override
  State<ClienteListPage> createState() => _ClienteListPageState();
}

class _ClienteListPageState extends State<ClienteListPage> {

  @override
  void initState() {
    super.initState();

    // Carrega os clientes assim que a tela é exibida.
    Future.microtask(
      () => Provider.of<ClienteViewModel>(
        context,
        listen: false,
      ).carregarClientes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtém o ViewModel para acessar lista, carregamento e métodos
    final viewModel = Provider.of<ClienteViewModel>(context);

    // Copia a lista original e ordena alfabeticamente
    final clientesOrdenados = [...viewModel.clientes];
    clientesOrdenados.sort(
      (a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Clientes"),
        centerTitle: true,
      ),

      // Corpo da página (listagem ou mensagem)
      body: viewModel.carregando
          // Mostra carregando se o ViewModel ainda está buscando os dados
          ? const Center(child: CircularProgressIndicator())

          // Se não houver clientes, exibe mensagem
          : clientesOrdenados.isEmpty
              ? const Center(
                  child: Text(
                    "Nenhum cliente cadastrado.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )

              // Caso tenha clientes, exibe a lista
              : ListView.builder(
                  itemCount: clientesOrdenados.length,
                  itemBuilder: (context, index) {
                    final Cliente cliente = clientesOrdenados[index];

                    return Card(
                      color: const Color.fromARGB(255, 253, 212, 226),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),

                      child: ListTile(
                        // Avatar com ícone
                        leading: CircleAvatar(
                          backgroundColor: Colors.pink.shade300,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),

                        // Nome do cliente
                        title: Text(
                          cliente.nome,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        // Telefone e e-mail
                        subtitle: Text(
                          "${cliente.telefone}\n${cliente.email ?? 'Sem e-mail'}",
                          style: const TextStyle(color: Colors.black54),
                        ),

                        isThreeLine: true, // Permite duas linhas no subtitle

                        // Menu de opções (Editar / Excluir)
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'edit') {
                              // Abre o formulário preenchido para edição
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ClienteFormPage(cliente: cliente),
                                ),
                              );
                            } else if (value == 'delete') {
                              // Remove o cliente
                              await viewModel.removerCliente(cliente.id!);
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
                    );
                  },
                ),

      // Botão flutuante para adicionar cliente
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Abre a página de novo cliente
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ClienteFormPage(),
            ),
          );
        },
        backgroundColor: Colors.pink.shade300,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
