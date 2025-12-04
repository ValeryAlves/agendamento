import 'package:agendamento/services/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../models/servico.dart';

class ServicoService {
  // Lista todos os serviços
  Future<List<Servico>> getServicos() async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('servico');
    return List.generate(maps.length, (i) => Servico.fromMap(maps[i]));
  }

  // Insere novo serviço
  Future<int> insertServico(Servico servico) async {
    final db = await DatabaseHelper.database;
    return db.insert('servico', servico.toMap());
  }

  // Atualiza serviço existente
  Future<int> updateServico(Servico servico) async {
    final db = await DatabaseHelper.database;
    return db.update(
      'servico',
      servico.toMap(),
      where: 'id = ?',
      whereArgs: [servico.id],
    );
  }

  // Exclui serviço
  Future<int> deleteServico(int id) async {
    final db = await DatabaseHelper.database;
    return db.delete('servico', where: 'id = ?', whereArgs: [id]);
  }
}
