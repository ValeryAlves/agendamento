import 'package:flutter/material.dart';
import '../../models/funcionario.dart';
import '../../services/funcionario_service.dart';

class FuncionarioViewModel extends ChangeNotifier {

  // Serviço responsável por CRUD de funcionários no banco
  final FuncionarioService _service = FuncionarioService();

  // Lista de funcionários carregados na Interface do Usuário (UI)
  List<Funcionario> funcionarios = [];

  // Indicador de carregamento
  bool carregando = false;

  // ----------------------------
  // CARREGA todos os funcionários do banco
  // ----------------------------
  Future<void> carregarFuncionarios() async {
    carregando = true;          // ativa indicador de carregamento
    notifyListeners();          // notifica UI para atualizar
    funcionarios = await _service.getFuncionarios(); // busca funcionários no DB
    carregando = false;         // desativa indicador
    notifyListeners();          // notifica UI novamente para atualizar lista
  }

  // ----------------------------
  // ADICIONA um novo funcionário
  // ----------------------------
  Future<void> adicionarFuncionario(Funcionario funcionario) async {
    await _service.insertFuncionario(funcionario); // insere no DB
    await carregarFuncionarios();                  // recarrega lista para atualizar UI
  }

  // ----------------------------
  // ATUALIZA um funcionário existente
  // ----------------------------
  Future<void> atualizarFuncionario(Funcionario funcionario) async {
    await _service.updateFuncionario(funcionario); // atualiza no DB
    await carregarFuncionarios();                  // recarrega lista
  }

  // ----------------------------
  // REMOVE um funcionário pelo ID
  // ----------------------------
  Future<void> removerFuncionario(int id) async {
    await _service.deleteFuncionario(id); // remove do DB
    await carregarFuncionarios();          // recarrega lista
  }
}
