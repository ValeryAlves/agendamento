import 'package:agendamento/services/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../models/cliente.dart';

class ClienteService {
  /// Retorna todos os clientes cadastrados
  Future<List<Cliente>> getClientes() async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('cliente');
    return List.generate(maps.length, (i) => Cliente.fromMap(maps[i]));
  }

  /// Insere um novo cliente
  Future<int> insertCliente(Cliente cliente) async {
    final db = await DatabaseHelper.database;
    return db.insert('cliente', cliente.toMap());
  }

  /// Atualiza um cliente existente
  Future<int> updateCliente(Cliente cliente) async {
    final db = await DatabaseHelper.database;
    return db.update(
      'cliente',
      cliente.toMap(),
      where: 'id = ?',
      whereArgs: [cliente.id],
    );
  }

  /// Exclui um cliente pelo ID
  Future<int> deleteCliente(int id) async {
    final db = await DatabaseHelper.database;
    return db.delete('cliente', where: 'id = ?', whereArgs: [id]);
  }
}
