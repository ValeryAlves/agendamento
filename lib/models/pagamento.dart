class Pagamento {
  final int? id;
  final String tipo;

   // Construtor da classe Pagamento (criar o objeto e defini seus atributos)
  Pagamento({
    this.id, 
    required this.tipo
  });

 // Converte o objeto Pagamento em um mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id, 
      'tipo': tipo
    };
  }

  // Cria um objeto Pagamento partir dos dados carregados do banco
  factory Pagamento.fromMap(Map<String, dynamic> map) {
    return Pagamento(
      id: map['id'],
      tipo: map['tipo'],
    );
  }
}
