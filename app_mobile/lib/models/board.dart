class Board {
  const Board({required this.id, required this.name});

  final int id;
  final String name;

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(id: json['id'] as int, name: json['nome'] as String);
  }
}
