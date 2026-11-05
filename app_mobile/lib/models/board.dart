
class Board {
  const Board({
    required this.id,
    required this.name,
    required this.type,
  });

  final int id;
  final String name;
  final String type;

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      id: json['id'] as int,
      name: json['nome'] as String,
      type: json['tipo'] as String? ?? 'tarefas',
    );
  }
}
