import 'package:flutter/material.dart';
import '../../models/cliente.dart';
import '../../services/cliente_service.dart';

class ClienteViewModel extends ChangeNotifier {

  // Serviço responsável por CRUD de clientes no banco
  final ClienteService _service = ClienteService();

  // Lista de clientes carregados na Interface do Usuário (UI)
  List<Cliente> clientes = [];

  // Indicador de carregamento
  bool carregando = false;

  // ----------------------------
  // CARREGA todos os clientes do banco
  // ----------------------------
  Future<void> carregarClientes() async {
    carregando = true;        // ativa indicador de carregamento
    notifyListeners();        // notifica UI para atualizar
    clientes = await _service.getClientes(); // busca clientes no DB
    carregando = false;       // desativa indicador
    notifyListeners();        // notifica UI novamente para atualizar lista
  }

  // ----------------------------
  // ADICIONA um novo cliente
  // ----------------------------
  Future<void> adicionarCliente(Cliente cliente) async {
    await _service.insertCliente(cliente); // insere no DB
    await carregarClientes();              // recarrega lista para atualizar UI
  }

  // ----------------------------
  // ATUALIZA um cliente existente
  // ----------------------------
  Future<void> atualizarCliente(Cliente cliente) async {
    await _service.updateCliente(cliente); // atualiza no DB
    await carregarClientes();              // recarrega lista
  }

  // ----------------------------
  // REMOVE um cliente pelo ID
  // ----------------------------
  Future<void> removerCliente(int id) async {
    await _service.deleteCliente(id); // remove do DB
    await carregarClientes();          // recarrega lista
  }
}
