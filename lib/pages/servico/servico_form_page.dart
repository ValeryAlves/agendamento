import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/servico.dart';
import '../../mvvm/viewmodels/servico_viewmodel.dart';

/// TELA: Formulário de Cadastro/Edição de Serviço
class ServicoFormPage extends StatefulWidget {
  final Servico? servico; // Serviço opcional para edição

  const ServicoFormPage({super.key, this.servico});

  @override
  State<ServicoFormPage> createState() => _ServicoFormPageState();
}

class _ServicoFormPageState extends State<ServicoFormPage> {
  // Chave global usada para validar o formulário
  final _formKey = GlobalKey<FormState>();

  // Controllers para manipular textos digitados nos inputs
  final _nomeController = TextEditingController();
  final _valorController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Caso esteja editando, preenche automaticamente os campos
    if (widget.servico != null) {
      _nomeController.text = widget.servico!.nome;
      _valorController.text = widget.servico!.valor.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtém o ViewModel para manipular dados de serviço
    final viewModel = Provider.of<ServicoViewModel>(context, listen: false);

    // Identifica se a página está no modo de edição
    final editando = widget.servico != null;

    return Scaffold(
      // Barra superior com o nome da tela
      appBar: AppBar(
        title: Text(editando ? "Editar Serviço" : "Novo Serviço"),
        centerTitle: true,
      ),

      // Conteúdo principal da tela
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: Colors.grey.shade100, // cor de fundo do card
          elevation: 4, // sombra
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          child: Padding(
            padding: const EdgeInsets.all(16),

            // Formulário contendo os campos
            child: Form(
              key: _formKey,
              child: Column(
                children: [

                  // CAMPO: Nome do Serviço
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: "Nome do Serviço",
                    ),
                    // Validação: campo não pode estar vazio
                    validator: (v) =>
                        v == null || v.isEmpty ? "Informe o nome" : null,
                  ),

                  const SizedBox(height: 16),

                  // CAMPO: Valor do Serviço
                  TextFormField(
                    controller: _valorController,
                    keyboardType: TextInputType.number, // Apenas números
                    decoration: const InputDecoration(
                      labelText: "Valor (R\$)",
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Informe o valor" : null,
                  ),

                  const SizedBox(height: 24),

                  // BOTÃO: Salvar serviço (criar ou editar)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade400,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    // Ação ao clicar no botão
                    onPressed: () async {
                      // Valida os campos antes de salvar
                      if (_formKey.currentState!.validate()) {
                        // Cria um novo objeto serviço com os dados preenchidos
                        final novoServico = Servico(
                          id: widget.servico?.id, // mantém o id ao editar
                          nome: _nomeController.text,
                          valor: double.parse(_valorController.text),
                        );

                        // Atualiza ou adiciona dependendo do modo
                        if (editando) {
                          await viewModel.atualizarServico(novoServico);
                        } else {
                          await viewModel.adicionarServico(novoServico);
                        }

                        // Volta para a tela anterior
                        if (context.mounted) Navigator.pop(context);
                      }
                    },

                    // Ícone + texto do botão
                    icon: const Icon(Icons.save),
                    label: Text(
                      editando ? "Salvar Alterações" : "Cadastrar Serviço",
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