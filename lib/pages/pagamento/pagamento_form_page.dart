import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/pagamento.dart';
import '../../mvvm/viewmodels/pagamento_viewmodel.dart';

/// Tela usada para cadastrar ou editar uma forma de pagamento.
class PagamentoFormPage extends StatefulWidget {
  final Pagamento? pagamento; // Pagamento existente (modo edição)

  const PagamentoFormPage({super.key, this.pagamento});

  @override
  State<PagamentoFormPage> createState() => _PagamentoFormPageState();
}

class _PagamentoFormPageState extends State<PagamentoFormPage> {
  // Chave usada para validar os campos do formulário
  final _formKey = GlobalKey<FormState>();

  // Controller responsável por capturar o texto do campo "Tipo de Pagamento"
  final _tipoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Se estivermos editando, inicializamos o campo com o valor do objeto
    if (widget.pagamento != null) {
      _tipoController.text = widget.pagamento!.tipo;
    }
  }

  @override
  Widget build(BuildContext context) {
    // -----------------------------------------------------------------------
    // Obtém o ViewModel, mas sem escutar alterações (listen: false),
    // pois essa tela não depende de mudanças automáticas nos dados.
    // -----------------------------------------------------------------------
    final viewModel = Provider.of<PagamentoViewModel>(context, listen: false);

    // Define se estamos editando ou criando um novo pagamento
    final editando = widget.pagamento != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? "Editar Pagamento" : "Nova Forma de Pagamento"),
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

            // Formulário que permite validações automáticas
            child: Form(
              key: _formKey,

              child: Column(
                children: [

                  /// Campo de entrada: Tipo de Pagamento
                  TextFormField(
                    controller: _tipoController,
                    decoration: const InputDecoration(
                      labelText: "Tipo de Pagamento",
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Informe o tipo" : null,
                  ),

                  const SizedBox(height: 24),

                  /// Botão principal da tela
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
                      // Verifica se todos os campos passaram na validação
                      if (_formKey.currentState!.validate()) {
                        // Cria uma instância de pagamento com os dados preenchidos
                        final novoPagamento = Pagamento(
                          id: widget.pagamento?.id, // Mantém o ID se estiver editando
                          tipo: _tipoController.text,
                        );

                        // Editar ou adicionar conforme o caso
                        if (editando) {
                          await viewModel.atualizarPagamento(novoPagamento);
                        } else {
                          await viewModel.adicionarPagamento(novoPagamento);
                        }

                        // Fecha a tela após salvar
                        if (context.mounted) Navigator.pop(context);
                      }
                    },

                    icon: const Icon(Icons.save),
                    label: Text(
                      editando ? "Salvar Alterações" : "Cadastrar Pagamento",
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