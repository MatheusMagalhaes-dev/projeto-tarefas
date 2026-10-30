class Task {
  const Task({
    required this.id,
    required this.title,
    this.description,
    this.completed = false,
    this.listId,
  });

  final int id;
  final String title;
  final String? description;
  final bool completed;
  final int? listId;

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      title: json['titulo'] as String,
      description: json['descricao'] as String?,
      completed: json['concluida'] as bool? ?? false,
      listId: json['lista_id'] as int?,
    );
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'titulo': title,
      'descricao': description,
      'concluida': completed,
      'lista_id': listId,
    };
  }
}
