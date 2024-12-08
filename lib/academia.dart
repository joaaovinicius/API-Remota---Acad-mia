// lib/academia.dart
class Academia {
  final String nome;
  final String localizacao;
  final String tipo;
  final String horarioFuncionamento;

  // Construtor
  Academia({
    required this.nome,
    required this.localizacao,
    required this.tipo,
    required this.horarioFuncionamento,
  });

  // Método para criar uma instância de Academia a partir de um JSON
  factory Academia.fromJson(Map<String, dynamic> json) {
    return Academia(
      nome: json['nome'],
      localizacao: json['localizacao'],
      tipo: json['tipo'],
      horarioFuncionamento: json['horario_funcionamento'],
    );
  }
}
