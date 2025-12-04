import 'package:agendamento/services/servico_service.dart';
import 'package:flutter/material.dart';
import '../../models/servico.dart';

class ServicoViewModel extends ChangeNotifier {
  // Serviço responsável por CRUD de Servico no banco
  final ServicoService _service = ServicoService();

  // Lista de serviços carregados na Interface do Usuário (UI)
  List<Servico> servicos = [];

  // Indicador de carregamento
  bool carregando = false;

  // ----------------------------
  // CARREGA todos os serviços do BD
  // ----------------------------
  Future<void> carregarServicos() async {
    carregando = true; // sinaliza início do carregamento
    notifyListeners(); // notifica UI para exibir loading, se houver
    servicos = await _service.getServicos(); // busca serviços do DB
    carregando = false; // sinaliza fim do carregamento
    notifyListeners(); // notifica UI para atualizar lista
  }

  // ----------------------------
  // ADICIONA um novo serviço
  // ----------------------------
  Future<void> adicionarServico(Servico servico) async {
    await _service.insertServico(servico); // insere no DB
    await carregarServicos(); // recarrega lista atualizada
  }

  // ----------------------------
  // ATUALIZA um serviço existente
  // ----------------------------
  Future<void> atualizarServico(Servico servico) async {
    await _service.updateServico(servico); // atualiza no DB
    await carregarServicos(); // recarrega lista atualizada
  }

  // ----------------------------
  // REMOVE um servico por ID
  // ----------------------------
  Future<void> removerServico(int id) async {
    await _service.deleteServico(id); // remove do DB pelo ID
    await carregarServicos(); // recarrega lista atualizada
  }
}
