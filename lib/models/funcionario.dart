class Funcionario {
  final int? id;
  final String nome;
  final String cargo;
  final String telefone;

  // Construtor da classe Funcionario (criar o objeto e defini seus atributos)
  Funcionario({
    this.id,
    required this.nome,
    required this.cargo,
    required this.telefone,
  });

  // Converte o objeto Funcionario em um mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id, 
      'nome': nome, 
      'cargo': cargo, 
      'telefone': telefone
    };
  }

  // Cria um objeto Funcionario a partir dos dados carregados do banco
  factory Funcionario.fromMap(Map<String, dynamic> map) {
    return Funcionario(
      id: map['id'],
      nome: map['nome'],
      cargo: map['cargo'],
      telefone: map['telefone'],
    );
  }
}
