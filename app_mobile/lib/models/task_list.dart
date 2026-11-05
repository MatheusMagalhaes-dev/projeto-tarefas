
class TaskList {
  const TaskList({
    required this.id,
    required this.name,
    required this.boardId,
    required this.order,
  });

  final int id;
  final String name;
  final int boardId;
  final int order;

  factory TaskList.fromJson(Map<String, dynamic> json) {
    return TaskList(
      id: json['id'] as int,
      name: json['nome'] as String,
      boardId: json['quadro_id'] as int,
      order: json['ordem'] as int,
    );
  }
}
