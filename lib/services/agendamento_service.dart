import 'package:agendamento/services/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/agendamento.dart';

class AgendamentoService {
  // Obtém a instância do banco de dados SQLite
  Future<Database> get _db async => await DatabaseHelper.database;

  // Retorna agendamentos com detalhes completos 
  // Utiliza JOINs para montar um único objeto detalhado
  Future<List<Map<String, dynamic>>> getAgendamentosDetalhados() async {
    final db = await _db;
    return await db.rawQuery('''
      SELECT 
        a.id,
        a.data,
        a.hora,
        a.valorTotal,
        a.pago,
        a.realizado,
        c.nome AS cliente,
        f.nome AS funcionario,
        s.nome AS servico,
        p.tipo AS pagamento
      FROM agendamento a
      LEFT JOIN cliente c ON a.idCliente = c.id
      LEFT JOIN funcionario f ON a.idFuncionario = f.id
      LEFT JOIN servico s ON a.idServico = s.id
      LEFT JOIN pagamento p ON a.idPagamento = p.id
      ORDER BY a.data DESC, a.hora DESC
    ''');
  }

  // Carrega todos os agendamentos simples
  Future<List<Agendamento>> getAgendamentos() async {
    final db = await _db;
    final maps = await db.query('agendamento');
    return List.generate(maps.length, (i) => Agendamento.fromMap(maps[i]));
  }

  // Insere novo agendamento no banco
  Future<int> insertAgendamento(Agendamento ag) async {
    final db = await _db;
    return db.insert('agendamento', ag.toMap());
  }

  // Atualiza um agendamento existente
  Future<int> updateAgendamento(Agendamento ag) async {
    final db = await _db;
    return db.update(
      'agendamento',
      ag.toMap(),
      where: 'id = ?',
      whereArgs: [ag.id],
    );
  }

  // Remove um agendamento pelo ID
  Future<int> deleteAgendamento(int id) async {
    final db = await _db;
    return db.delete('agendamento', where: 'id = ?', whereArgs: [id]);
  }

  // Apaga todos os agendamentos da tabela
  Future<void> clearAgendamentos() async {
    final db = await _db;
    await db.delete('agendamento');
  }

  // Conta total de agendamentos cadastrados
  Future<int> getTotalAgendamentos() async {
    final db = await _db;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM agendamento',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Conta quantos agendamentos existem para uma data específica
  Future<int> getAgendamentosPorData(String data) async {
    final db = await _db;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM agendamento WHERE data = ?',
      [data],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Conta agendamentos dentro de um intervalo de datas
  Future<int> getAgendamentosEntreDatas(
    String dataInicio,
    String dataFim,
  ) async {
    final db = await _db;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM agendamento WHERE data BETWEEN ? AND ?',
      [dataInicio, dataFim],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Conta quantos agendamentos ainda NÃO foram realizados
  Future<int> getAgendamentosNaoRealizados() async {
    final db = await _db;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM agendamento WHERE realizado = 0',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
