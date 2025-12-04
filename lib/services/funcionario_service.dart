import 'package:agendamento/services/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../models/funcionario.dart';

class FuncionarioService {
  /// Retorna todos os funcionários cadastrados
  Future<List<Funcionario>> getFuncionarios() async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('funcionario');
    return List.generate(maps.length, (i) => Funcionario.fromMap(maps[i]));
  }

  /// Insere um novo funcionário
  Future<int> insertFuncionario(Funcionario funcionario) async {
    final db = await DatabaseHelper.database;
    return db.insert('funcionario', funcionario.toMap());
  }

  /// Atualiza um funcionário existente
  Future<int> updateFuncionario(Funcionario funcionario) async {
    final db = await DatabaseHelper.database;
    return db.update(
      'funcionario',
      funcionario.toMap(),
      where: 'id = ?',
      whereArgs: [funcionario.id],
    );
  }

  /// Exclui um funcionário pelo ID
  Future<int> deleteFuncionario(int id) async {
    final db = await DatabaseHelper.database;
    return db.delete('funcionario', where: 'id = ?', whereArgs: [id]);
  }
}
