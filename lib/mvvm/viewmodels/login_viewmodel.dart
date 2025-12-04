import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  // ----------------------------
  // Flag que indica se o usuário está logado
  // ----------------------------
  bool logado = false;

  // ----------------------------
  // MÉTODO DE LOGIN
  // ----------------------------
  void login(String usuario, String senha) {
    // Aqui você poderia conectar com banco de dados ou API real
    if (usuario == 'admin' && senha == '1234') {
      logado = true; // atualiza estado para "logado"
      notifyListeners(); // notifica UI para atualizar (ex: mostrar tela inicial)
    }
  }

  // ----------------------------
  // MÉTODO DE LOGOUT
  // ----------------------------
  void logout() {
    logado = false; // atualiza estado para "deslogado"
    notifyListeners(); // notifica UI para atualizar (ex: voltar para tela de login)
  }
}
