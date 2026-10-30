import 'package:flutter/material.dart';

import '../models/task.dart';
import '../models/task_list.dart';

class TaskListCard extends StatelessWidget {
  const TaskListCard({
    super.key,
    required this.list,
    required this.tasks,
    required this.onAddTask,
    required this.onDeleteList,
    required this.onToggleTask,
    required this.onEditTask,
    required this.onDeleteTask,
  });

  final TaskList list;
  final List<Task> tasks;

  final VoidCallback onAddTask;
  final VoidCallback onDeleteList;
  final ValueChanged<Task> onToggleTask;
  final ValueChanged<Task> onEditTask;
  final ValueChanged<Task> onDeleteTask;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    list.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(onPressed: onAddTask, icon: const Icon(Icons.add)),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      onDeleteList();
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Excluir lista'),
                    ),
                  ],
                ),
              ],
            ),
            if (tasks.isEmpty)
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text('Nenhuma tarefa nesta lista.'),
              )
            else
              ...tasks.map(
                (task) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Checkbox(
                    value: task.completed,
                    onChanged: (_) => onToggleTask(task),
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle:
                      task.description == null || task.description!.isEmpty
                      ? null
                      : Text(task.description!),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEditTask(task);
                      }

                      if (value == 'delete') {
                        onDeleteTask(task);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('Editar')),
                      PopupMenuItem(value: 'delete', child: Text('Excluir')),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
