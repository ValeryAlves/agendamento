import 'package:agendamento/services/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../models/pagamento.dart';

class PagamentoService {
  /// Retorna todos os pagamentos cadastrados
  Future<List<Pagamento>> getPagamentos() async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('pagamento');
    return List.generate(maps.length, (i) => Pagamento.fromMap(maps[i]));
  }

  /// Insere um novo pagamento
  Future<int> insertPagamento(Pagamento pagamento) async {
    final db = await DatabaseHelper.database;
    return db.insert('pagamento', pagamento.toMap());
  }

  /// Atualiza um pagamento existente
  Future<int> updatePagamento(Pagamento pagamento) async {
    final db = await DatabaseHelper.database;
    return db.update(
      'pagamento',
      pagamento.toMap(),
      where: 'id = ?',
      whereArgs: [pagamento.id],
    );
  }

  /// Exclui um pagamento pelo ID
  Future<int> deletePagamento(int id) async {
    final db = await DatabaseHelper.database;
    return db.delete('pagamento', where: 'id = ?', whereArgs: [id]);
  }
}
