import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../mvvm/viewmodels/login_viewmodel.dart';

/// Tela de Login da aplicação.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controladores dos campos de texto
  final _usuarioCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();

  // Variável que guarda mensagens de erro
  String? _erro;

  @override
  Widget build(BuildContext context) {
    // Acessa o ViewModel responsável pelo login
    final loginVm = Provider.of<LoginViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 40),
          child: Container(
            width: double.infinity,
            // Garante que a área pega pelo menos toda a tela
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),

            // Fundo com degradê rosa
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFC1D6), Color(0xFFFFE4EC)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),

            // Conteúdo centralizado
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),

                // Moldura com bordas arredondadas + blur (efeito vidro fosco)
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),

                    child: Container(
                      width: 380,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 1.2,
                        ),
                      ),

                      // Conteúdo da caixa de login
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Ícone principal
                          const Icon(
                            Icons.lock_outline,
                            size: 60,
                            color: Colors.pink,
                          ),
                          const SizedBox(height: 12),

                          // Título
                          const Text(
                            "Bem-vindo",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Subtítulo
                          Text(
                            "Faça login para continuar",
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Campo de usuário
                          TextField(
                            controller: _usuarioCtrl,
                            decoration: InputDecoration(
                              labelText: "Usuário",
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Campo de senha
                          TextField(
                            controller: _senhaCtrl,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Senha",
                              prefixIcon: const Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Exibe mensagem de erro quando necessário
                          if (_erro != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Text(
                                _erro!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          // Botão "Entrar"
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink.shade400,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () {
                                // Validação simples de login
                                if (_usuarioCtrl.text == 'admin' &&
                                    _senhaCtrl.text == '1234') {
                                  
                                  // Chama método de login do ViewModel
                                  loginVm.login(
                                    _usuarioCtrl.text,
                                    _senhaCtrl.text,
                                  );

                                  // Remove mensagem de erro
                                  setState(() => _erro = null);

                                  // Aqui você pode navegar para a HomePage,
                                  // caso seu ViewModel não faça isso automaticamente
                                } else {
                                  // Login incorreto → exibe erro
                                  setState(
                                    () => _erro = "Usuário ou senha incorretos",
                                  );
                                }
                              },
                              child: const Text(
                                'Entrar',
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
