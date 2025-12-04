class Agendamento {
  final int? id;
  final int idCliente;
  final int idFuncionario;
  final int idServico;
  final int idPagamento;
  final String data;
  final String hora;
  final double valorTotal;
  final bool pago;
  final bool realizado;

  // Construtor da classe Agendamento (criar o objeto e defini seus atributos)
  Agendamento({
    this.id,
    required this.idCliente,
    required this.idFuncionario,
    required this.idServico,
    required this.idPagamento,
    required this.data,
    required this.hora,
    required this.valorTotal,
    required this.pago,
    required this.realizado,
  });

  // Converte a classe em um mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idCliente': idCliente,
      'idFuncionario': idFuncionario,
      'idServico': idServico,
      'idPagamento': idPagamento,
      'data': data,
      'hora': hora,
      'valorTotal': valorTotal,
      // Banco SQLite não tem boolean, então converte: true → 1, false → 0
      'pago': pago ? 1 : 0,
      'realizado': realizado ? 1 : 0,
    };
  }

  // Cria um objeto Agendamento a partir de um mapa (vindo do banco)
  factory Agendamento.fromMap(Map<String, dynamic> map) {
    return Agendamento(
      id: map['id'],
      idCliente: map['idCliente'],
      idFuncionario: map['idFuncionario'],
      idServico: map['idServico'],
      idPagamento: map['idPagamento'],
      data: map['data'],
      hora: map['hora'],
      valorTotal: map['valorTotal'],
      // Converte de int do banco para bool do Dart
      pago: map['pago'] == 1,
      realizado: map['realizado'] == 1,
    );
  }

    // Cria uma nova instância de Agendamento alterando só os campos informados
    Agendamento copyWith({
      int? id,
      int? idCliente,
      int? idFuncionario,
      int? idServico,
      int? idPagamento,
      double? valorTotal,
      String? data,
      String? hora,
      bool? pago,
      bool? realizado,
    }) {
      return Agendamento(
        id: id ?? this.id,         // Usa o novo valor ou mantém o atual
        idCliente: idCliente ?? this.idCliente,
        idFuncionario: idFuncionario ?? this.idFuncionario,
        idServico: idServico ?? this.idServico,
        idPagamento: idPagamento ?? this.idPagamento,
        valorTotal: valorTotal ?? this.valorTotal,
        data: data ?? this.data,
        hora: hora ?? this.hora,
        pago: pago ?? this.pago,
        realizado: realizado ?? this.realizado,
      );
    }
}