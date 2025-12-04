class Cliente {
  final int? id;
  final String nome;
  final String telefone;
  final String? email;

  // Construtor da classe Cliente (criar o objeto e defini seus atributos)
  Cliente({
    this.id, 
    required this.nome, 
    required this.telefone, 
    this.email
    });

  // Converte o objeto Cliente em um mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id, 
      'nome': nome, 
      'telefone': telefone, 
      'email': email
    };
  }

  // Cria um objeto Cliente a partir dos dados carregados do banco
  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'],
      nome: map['nome'],
      telefone: map['telefone'],
      email: map['email'],
    );
  }
}
