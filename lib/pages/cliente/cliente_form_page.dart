import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/cliente.dart';
import '../../mvvm/viewmodels/cliente_viewmodel.dart';

/// Tela de formulário para criar ou editar um cliente.
class ClienteFormPage extends StatefulWidget {
  final Cliente? cliente;

  const ClienteFormPage({super.key, this.cliente});

  @override
  State<ClienteFormPage> createState() => _ClienteFormPageState();
}

class _ClienteFormPageState extends State<ClienteFormPage> {
  // Chave do formulário para validações
  final _formKey = GlobalKey<FormState>();

  // Controladores que capturam o texto digitado nos campos
  final _nomeCtrl = TextEditingController();
  final _telefoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Se estiver editando um cliente → preenche os campos com os dados atuais
    if (widget.cliente != null) {
      _nomeCtrl.text = widget.cliente!.nome;
      _telefoneCtrl.text = widget.cliente!.telefone;
      _emailCtrl.text = widget.cliente!.email ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Acesso ao ViewModel de clientes, sem ficar observando mudanças
    final vm = Provider.of<ClienteViewModel>(context, listen: false);

    // Flag para saber se é edição ou cadastro novo
    final editando = widget.cliente != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? "Editar Cliente" : "Novo Cliente"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        // Card visual para melhorar aparência
        child: Card(
          color: Colors.grey.shade100,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          child: Padding(
            padding: const EdgeInsets.all(16),

            // Formulário com validações
            child: Form(
              key: _formKey,

              child: Column(
                children: [

                  // CAMPO: Nome
                  TextFormField(
                    controller: _nomeCtrl,
                    decoration: const InputDecoration(labelText: "Nome"),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Informe o nome" : null,
                  ),

                  const SizedBox(height: 16),

                  // CAMPO: Telefone
                  TextFormField(
                    controller: _telefoneCtrl,
                    decoration: const InputDecoration(labelText: "Telefone"),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Informe o telefone" : null,
                  ),

                  const SizedBox(height: 16),

                  // CAMPO: E-mail 
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(
                      labelText: "E-mail (opcional)",
                    ),
                  ),

                  const SizedBox(height: 24),

                  // BOTÃO de SALVAR
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
                      // Se o formulário estiver válido
                      if (_formKey.currentState!.validate()) {
                        // Monta um objeto Cliente com os dados digitados
                        final cliente = Cliente(
                          id: widget.cliente?.id, // mantém ID ao editar
                          nome: _nomeCtrl.text,
                          telefone: _telefoneCtrl.text,
                          email: _emailCtrl.text.isEmpty
                              ? null
                              : _emailCtrl.text,
                        );

                        // Se for edição → atualizar
                        // Se for novo → adicionar
                        if (editando) {
                          await vm.atualizarCliente(cliente);
                        } else {
                          await vm.adicionarCliente(cliente);
                        }

                        // Fecha a tela e volta para a lista
                        if (context.mounted) Navigator.pop(context);
                      }
                    },

                    icon: const Icon(Icons.save),
                    label: Text(
                      editando ? "Salvar Alterações" : "Cadastrar Cliente",
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