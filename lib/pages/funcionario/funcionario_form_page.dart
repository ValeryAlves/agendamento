import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/funcionario.dart';
import '../../mvvm/viewmodels/funcionario_viewmodel.dart';

/// Tela utilizada para cadastrar ou editar um funcionário.
class FuncionarioFormPage extends StatefulWidget {
  final Funcionario? funcionario;

  const FuncionarioFormPage({super.key, this.funcionario});

  @override
  State<FuncionarioFormPage> createState() => _FuncionarioFormPageState();
}

class _FuncionarioFormPageState extends State<FuncionarioFormPage> {
  // Chave global para acessar e validar o formulário
  final _formKey = GlobalKey<FormState>();

  // Controladores dos campos de texto
  final _nomeController = TextEditingController();
  final _cargoController = TextEditingController();
  final _telefoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Se estiver editando, preenche automaticamente os campos
    if (widget.funcionario != null) {
      _nomeController.text = widget.funcionario!.nome;
      _cargoController.text = widget.funcionario!.cargo;
      _telefoneController.text = widget.funcionario!.telefone;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtém o ViewModel, porém sem "escutar" atualizações
    final viewModel = Provider.of<FuncionarioViewModel>(context, listen: false);

    // Verifica se é edição (true) ou novo cadastro (false)
    final editando = widget.funcionario != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? "Editar Funcionário" : "Novo Funcionário"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Card(
          color: Colors.grey.shade100,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          child: Padding(
            padding: const EdgeInsets.all(16),

            // Formulário que agrupa e valida os campos
            child: Form(
              key: _formKey,

              child: Column(
                children: [

                  // Campo: Nome do funcionário
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: "Nome do Funcionário",
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Informe o nome" : null,
                  ),

                  const SizedBox(height: 16),

                  // Campo: Cargo / Função
                  TextFormField(
                    controller: _cargoController,
                    decoration: const InputDecoration(labelText: "Cargo"),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Informe o cargo" : null,
                  ),

                  const SizedBox(height: 16),

                  // Campo: Telefone
                  TextFormField(
                    controller: _telefoneController,
                    decoration: const InputDecoration(labelText: "Telefone"),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Informe o telefone" : null,
                  ),

                  const SizedBox(height: 24),
                  
                  // Botão para salvar o funcionário (edição ou novo)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade400,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    onPressed: () async {
                      // Validação dos campos antes de salvar
                      if (_formKey.currentState!.validate()) {
                        // Cria um objeto funcionário com os valores dos campos
                        final novoFuncionario = Funcionario(
                          id: widget.funcionario?.id, // mantém o ID em edição
                          nome: _nomeController.text,
                          cargo: _cargoController.text,
                          telefone: _telefoneController.text,
                        );

                        // Se for edição → atualizar
                        if (editando) {
                          await viewModel.atualizarFuncionario(novoFuncionario);
                        }
                        // Caso contrário → adicionar
                        else {
                          await viewModel.adicionarFuncionario(novoFuncionario);
                        }

                        // Fecha a tela retornando para a anterior
                        if (context.mounted) Navigator.pop(context);
                      }
                    },

                    icon: const Icon(Icons.save),
                    label: Text(
                      editando ? "Salvar Alterações" : "Cadastrar Funcionário",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
