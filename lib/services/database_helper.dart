import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  // Singleton → garante apenas uma instância do DatabaseHelper
  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  static Database? _db;

  // Getter estático para obter a instância do banco
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  // Inicialização do banco SQLite
  // Cria o arquivo e as tabelas se não existirem
  static Future<Database> _initDB() async {
    // Caminho do diretório de documentos do app
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'agendamento.db');

    return openDatabase(
      path,
      version: 1, // versão do banco
      onCreate: (db, version) async {

        // Criação da tabela Cliente
        await db.execute('''
          CREATE TABLE cliente (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            telefone TEXT,
            email TEXT
          )
        ''');

        // Criação da tabela Funcionário
        await db.execute('''
          CREATE TABLE funcionario (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            cargo TEXT,
            telefone TEXT
          )
        ''');

        // Criação da tabela Serviço
        await db.execute('''
          CREATE TABLE servico (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            valor REAL
          )
        ''');

        // Criação da tabela Pagamento
        await db.execute('''
          CREATE TABLE pagamento (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tipo TEXT
          )
        ''');

        // Criação da tabela Agendamento com foreign keys
        await db.execute('''
          CREATE TABLE agendamento (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idCliente INTEGER,
            idFuncionario INTEGER,
            idServico INTEGER,
            idPagamento INTEGER,
            data TEXT,
            hora TEXT,
            valorTotal REAL,
            pago INTEGER,
            realizado INTEGER,
            FOREIGN KEY (idCliente) REFERENCES cliente (id),
            FOREIGN KEY (idFuncionario) REFERENCES funcionario (id),
            FOREIGN KEY (idServico) REFERENCES servico (id),
            FOREIGN KEY (idPagamento) REFERENCES pagamento (id)
          )
        ''');
      },

      // Atualização do banco (migrations)
      onUpgrade: (db, oldVersion, newVersion) async {
        // exemplo simples de upgrade
        if (oldVersion < 5) {
          await db.execute('DROP TABLE IF EXISTS pagamento');
          await db.execute('''
            CREATE TABLE pagamento (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              tipo TEXT
            )
          ''');
        }
      },
    );
  }

  // MÉTODOS DE ESTATÍSTICA

  // Total de agendamentos
  Future<int> getTotalAgendamentos() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM agendamento',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Agendamentos em uma data específica
  Future<int> getAgendamentosPorData(String data) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM agendamento WHERE data = ?',
      [data],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Agendamentos dentro de um intervalo de datas
  Future<int> getAgendamentosEntreDatas(
    String dataInicio,
    String dataFim,
  ) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM agendamento WHERE data BETWEEN ? AND ?',
      [dataInicio, dataFim],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Agendamentos ainda não realizados
  Future<int> getAgendamentosNaoRealizados() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM agendamento WHERE realizado = 0',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
