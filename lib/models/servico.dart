class Servico {
  final int? id;
  final String nome;
  final double valor;

// Construtor da classe Servico (criar o objeto e defini seus atributos)
  Servico({
    this.id, 
    required this.nome, 
    required this.valor
  });

  // Converte o objeto Servico em um mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id, 
      'nome': nome, 
      'valor': valor
    };
  }

 // Cria um objeto Servico a partir dos dados carregados do banco
  factory Servico.fromMap(Map<String, dynamic> map) {
    return Servico(
      id: map['id'],
      nome: map['nome'],
      valor: map['valor'] is int
          ? (map['valor'] as int).toDouble()
          : map['valor'],
    );
  }
}
