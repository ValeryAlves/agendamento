import 'package:flutter/material.dart';
import '../../models/agendamento.dart';
import '../../services/agendamento_service.dart';

class AgendamentoViewModel extends ChangeNotifier {
  // Serviço responsável por CRUD no banco
  final AgendamentoService _service = AgendamentoService();

  // Lista de agendamentos carregados na Interface do Usuário (UI)
  List<Agendamento> agendamentos = [];

  // Indicador de carregamento
  bool carregando = false;

  // ----------------------------
  // CARREGA todos os agendamentos do banco
  // ----------------------------
  Future<void> carregarAgendamentos() async {
    carregando = true; // ativa indicador de carregamento
    notifyListeners(); // notifica a UI para atualizar
    agendamentos = await _service.getAgendamentos(); // busca do DB
    carregando = false; // desativa indicador
    notifyListeners(); // atualiza UI novamente
  }

  // ----------------------------
  // ADICIONA um novo agendamento
  // ----------------------------
  Future<void> adicionarAgendamento(Agendamento ag) async {
    await _service.insertAgendamento(ag); // insere no DB
    await carregarAgendamentos(); // recarrega lista para atualizar UI
  }

  // ----------------------------
  // ATUALIZA um agendamento existente
  // ----------------------------
  Future<void> atualizarAgendamento(Agendamento ag) async {
    await _service.updateAgendamento(ag); // atualiza no DB
    await carregarAgendamentos(); // recarrega lista
  }

  // ----------------------------
  // REMOVE um agendamento pelo ID
  // ----------------------------
  Future<void> removerAgendamento(int id) async {
    await _service.deleteAgendamento(id); // deleta do DB
    await carregarAgendamentos(); // recarrega lista
  }
}
