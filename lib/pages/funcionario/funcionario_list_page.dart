import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../mvvm/viewmodels/funcionario_viewmodel.dart';
import '../../models/funcionario.dart';
import 'funcionario_form_page.dart';

/// Tela responsável por listar todos os funcionários cadastrados.
class FuncionarioListPage extends StatefulWidget {
  const FuncionarioListPage({super.key});

  @override
  State<FuncionarioListPage> createState() => _FuncionarioListPageState();
}

class _FuncionarioListPageState extends State<FuncionarioListPage> {
  @override
  void initState() {
    super.initState();

    // Ao abrir essa tela, carregamos os funcionários do ViewModel.
    Future.microtask(
      () => Provider.of<FuncionarioViewModel>(
        context,
        listen: false,
      ).carregarFuncionarios(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ouve o ViewModel — assim a tela atualiza quando houver mudanças
    final viewModel = Provider.of<FuncionarioViewModel>(context);

    // Criamos uma cópia da lista original para não alterar o ViewModel.
    // Em seguida, ordenamos alfabeticamente ignorando maiúsculas/minúsculas.
    final funcionariosOrdenados = [...viewModel.funcionarios];
    funcionariosOrdenados.sort(
      (a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Funcionários"), centerTitle: true),

      // Corpo da tela:
      body: viewModel.carregando
          ? const Center(child: CircularProgressIndicator())

          : funcionariosOrdenados.isEmpty
              ? const Center(
                  child: Text(
                    "Nenhum funcionário cadastrado ainda.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )

              : ListView.builder(
                  itemCount: funcionariosOrdenados.length,
                  itemBuilder: (context, index) {
                    final funcionario = funcionariosOrdenados[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      color: const Color.fromARGB(255, 253, 212, 226),

                      child: ListTile(
                        // Ícone circular
                        leading: CircleAvatar(
                          backgroundColor: Colors.pink.shade300,
                          child: const Icon(Icons.work, color: Colors.white),
                        ),

                        // Nome do funcionário
                        title: Text(
                          funcionario.nome,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        // Cargo + telefone
                        subtitle: Text(
                          "${funcionario.cargo} • ${funcionario.telefone}",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),

                        // Menu popup (Editar / Excluir)
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {

                            // Editar → abre a tela de formulário já com os dados preenchidos
                            if (value == 'edit') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FuncionarioFormPage(
                                    funcionario: funcionario,
                                  ),
                                ),
                              );
                            }

                            // Excluir → solicita ao ViewModel a remoção do funcionário
                            else if (value == 'delete') {
                              await viewModel.removerFuncionario(
                                funcionario.id!,
                              );
                            }
                          },

                          // Itens do menu
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

      // Botão flutuante para adicionar um novo funcionário.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const FuncionarioFormPage(),
            ),
          );
        },
        backgroundColor: Colors.pink.shade300,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
