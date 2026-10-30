import 'package:flutter/material.dart';

import '../controllers/task_controller.dart';
import '../models/board.dart';
import '../models/task.dart';
import '../models/task_list.dart';

import '../widgets/board_header.dart';
import '../widgets/task_form_dialog.dart';
import '../widgets/task_list_card.dart';
import '../widgets/text_input_dialog.dart';

class TaskHomePage extends StatefulWidget {
  const TaskHomePage({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  State<TaskHomePage> createState() => _TaskHomePageState();
}

class _TaskHomePageState extends State<TaskHomePage>
    with SingleTickerProviderStateMixin {
  late final TaskController _controller;

  late final AnimationController _completionController;
  late final Animation<double> _completionOpacity;

  @override
  void initState() {
    super.initState();

    _controller = TaskController();

    _completionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _completionOpacity = Tween<double>(begin: 0, end: 0.22).animate(
      CurvedAnimation(parent: _completionController, curve: Curves.easeOut),
    );

    _controller.loadBoards();
  }

  @override
  void dispose() {
    _completionController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _playCompletionPulse() {
    _completionController.forward(from: 0).then((_) {
      if (mounted) {
        _completionController.reverse();
      }
    });
  }

  void _showError(Object error) {
    debugPrint('Erro na operação: $error');

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Não foi possível realizar a operação.')),
    );
  }

  Future<bool> _confirmDialog(String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<String?> _showTextDialog({
    required String title,
    String initialValue = '',
    String label = 'Nome',
  }) {
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => TextInputDialog(
        title: title,
        initialValue: initialValue,
        label: label,
      ),
    );
  }

  // QUADROS

  Future<void> _createBoard() async {
    final name = await _showTextDialog(title: 'Novo quadro');

    if (name == null) return;

    try {
      await _controller.createBoard(name);
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _deleteBoard(Board board) async {
    if (!await _confirmDialog('Excluir o quadro "${board.name}"?')) {
      return;
    }

    try {
      await _controller.deleteBoard(board);
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _selectBoard(Board board) async {
    try {
      await _controller.selectBoard(board);
    } catch (error) {
      _showError(error);
    }
  }

  // LISTAS

  Future<void> _createList() async {
    final board = _controller.selectedBoard;

    if (board == null) return;

    final name = await _showTextDialog(title: 'Nova lista');

    if (name == null) return;

    try {
      await _controller.createList(name, board);
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _deleteList(TaskList list) async {
    if (!await _confirmDialog('Excluir a lista "${list.name}"?')) {
      return;
    }

    try {
      await _controller.deleteList(list);
    } catch (error) {
      _showError(error);
    }
  }

  // TAREFAS

  Future<void> _createTask(TaskList list) async {
    final result = await showDialog<TaskFormResult>(
      context: context,
      builder: (_) => const TaskFormDialog(),
    );

    if (result == null) return;

    try {
      await _controller.createTask(
        result.title,
        description: result.description,
        list: list,
      );
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _editTask(Task task) async {
    final result = await showDialog<TaskFormResult>(
      context: context,
      builder: (_) => TaskFormDialog(task: task),
    );

    if (result == null) return;

    final updatedTask = Task(
      id: task.id,
      title: result.title,
      description: result.description,
      completed: task.completed,
      listId: task.listId,
    );

    try {
      await _controller.updateTask(updatedTask);
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _toggleTask(Task task, bool? value) async {
    if (value == null) return;

    try {
      await _controller.toggleTask(task, value);

      if (value) {
        _playCompletionPulse();
      }
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _deleteTask(Task task) async {
    if (!await _confirmDialog('Excluir a tarefa "${task.title}"?')) {
      return;
    }

    try {
      await _controller.deleteTask(task);
    } catch (error) {
      _showError(error);
    }
  }

  // INTERFACE

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        final board = _controller.selectedBoard;

        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Minhas tarefas',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                actions: [
                  PopupMenuButton<ThemeMode>(
                    tooltip: 'Aparência',
                    initialValue: widget.themeMode,
                    onSelected: widget.onThemeChanged,
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: ThemeMode.system,
                        child: Text('Automático'),
                      ),
                      PopupMenuItem(
                        value: ThemeMode.light,
                        child: Text('Claro'),
                      ),
                      PopupMenuItem(
                        value: ThemeMode.dark,
                        child: Text('Escuro'),
                      ),
                    ],
                    icon: const Icon(Icons.palette_outlined),
                  ),
                  if (board != null)
                    PopupMenuButton<String>(
                      tooltip: 'Opções do quadro',
                      onSelected: (value) {
                        if (value == 'delete') {
                          _deleteBoard(board);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Excluir quadro'),
                        ),
                      ],
                    ),
                ],
              ),
              body: _controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _controller.errorMessage != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline, size: 48),
                            const SizedBox(height: 12),
                            Text(
                              _controller.errorMessage!,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            FilledButton(
                              onPressed: _controller.loadBoards,
                              child: const Text('Tentar novamente'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : board == null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.dashboard_outlined, size: 56),
                          const SizedBox(height: 16),
                          const Text('Nenhum quadro criado'),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: _createBoard,
                            icon: const Icon(Icons.add),
                            label: const Text('Criar quadro'),
                          ),
                        ],
                      ),
                    )
                  : _buildBoardContent(board),
              floatingActionButton: FloatingActionButton(
                onPressed: board == null ? _createBoard : _createList,
                child: const Icon(Icons.add),
              ),
            ),
            IgnorePointer(
              child: AnimatedBuilder(
                animation: _completionOpacity,
                builder: (_, _) => Container(
                  color: Colors.green.withValues(
                    alpha: _completionOpacity.value,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBoardContent(Board board) {
    final lists = _controller.listsByBoard[board.id] ?? [];

    return Column(
      children: [
        BoardHeader(
          board: board,
          boards: _controller.boards,
          onSelectBoard: _selectBoard,
          onCreateBoard: _createBoard,
        ),
        Expanded(
          child: lists.isEmpty
              ? Center(
                  child: FilledButton.icon(
                    onPressed: _createList,
                    icon: const Icon(Icons.add),
                    label: const Text('Criar lista'),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 88),
                  itemCount: lists.length,
                  itemBuilder: (_, index) {
                    final list = lists[index];
                    final tasks = _controller.tasksByList[list.id] ?? [];

                    return TaskListCard(
                      list: list,
                      tasks: tasks,
                      onAddTask: () => _createTask(list),
                      onDeleteList: () => _deleteList(list),
                      onToggleTask: (task) {
                        _toggleTask(task, !task.completed);
                      },
                      onEditTask: _editTask,
                      onDeleteTask: _deleteTask,
                    );
                  },
                ),
        ),
      ],
    );
  }
}
