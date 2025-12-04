import 'package:agendamento/services/pagamento_service.dart';
import 'package:flutter/material.dart';
import '../../models/pagamento.dart';

class PagamentoViewModel extends ChangeNotifier {
  // Serviço responsável por CRUD de Pagamento no banco
  final PagamentoService _service = PagamentoService();

  // Lista de pagamentos carregados na Interface do Usuário (UI)
  List<Pagamento> pagamentos = [];

  // Indicador de carregamento
  bool carregando = false;

  // ----------------------------
  // CARREGA todos os pagamentos do BD
  // ----------------------------
  Future<void> carregarPagamentos() async {
    carregando = true; // sinaliza início do carregamento
    notifyListeners(); // notifica UI para exibir loading, se houver
    pagamentos = await _service.getPagamentos(); // busca pagamentos do DB
    carregando = false; // sinaliza fim do carregamento
    notifyListeners(); // notifica UI para atualizar lista
  }

  // ----------------------------
  // ADICIONA um novo pagamento
  // ----------------------------
  Future<void> adicionarPagamento(Pagamento pagamento) async {
    await _service.insertPagamento(pagamento); // insere no DB
    await carregarPagamentos(); // recarrega lista atualizada
  }

  // ----------------------------
  // ATUALIZA um pagamento existente
  // ----------------------------
  Future<void> atualizarPagamento(Pagamento pagamento) async {
    await _service.updatePagamento(pagamento); // atualiza no DB
    await carregarPagamentos(); // recarrega lista atualizada
  }

  // ----------------------------
  // REMOVE um pagemento por ID
  // ----------------------------
  Future<void> removerPagamento(int id) async {
    await _service.deletePagamento(id); // remove do DB pelo ID
    await carregarPagamentos(); // recarrega lista atualizada
  }
}
