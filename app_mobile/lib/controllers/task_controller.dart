import 'package:flutter/foundation.dart';

import '../models/board.dart';
import '../models/task.dart';
import '../models/task_list.dart';
import '../services/task_api.dart';

class TaskController extends ChangeNotifier {
  final TaskApi _api = TaskApi();

  List<Board> _boards = [];
  Board? _selectedBoard;

  final Map<int, List<TaskList>> _listsByBoard = {};
  final Map<int, List<Task>> _tasksByList = {};

  bool _isLoading = true;
  String? _errorMessage;

  List<Board> get boards => _boards;
  Board? get selectedBoard => _selectedBoard;

  Map<int, List<TaskList>> get listsByBoard => _listsByBoard;
  Map<int, List<Task>> get tasksByList => _tasksByList;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadBoards() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _boards = await _api.getBoards();

      _selectedBoard = _boards.isEmpty ? null : _boards.first;

      if (_selectedBoard != null) {
        await loadBoardData(_selectedBoard!);
      }
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadBoardData(Board board) async {
    // Se o quadro já foi carregado, não precisamos consultar a API.
    if (_listsByBoard.containsKey(board.id)) {
      return;
    }

    final lists = await _api.getLists(board.id);

    final tasksByList = <int, List<Task>>{};

    for (final list in lists) {
      tasksByList[list.id] = await _api.getTasksFromList(list.id);
    }

    // Só guardamos os dados depois que todas as consultas terminarem.
    _listsByBoard[board.id] = lists;
    _tasksByList.addAll(tasksByList);

    notifyListeners();
  }

  Future<void> selectBoard(Board board) async {
    _selectedBoard = board;
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      await loadBoardData(board);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createBoard(String name) async {
    final board = await _api.createBoard(name);

    _boards.add(board);
    _selectedBoard = board;

    notifyListeners();

    await loadBoardData(board);
  }

  Future<void> deleteBoard(Board board) async {
    await _api.deleteBoard(board.id);

    _boards.removeWhere((item) => item.id == board.id);

    final lists = _listsByBoard.remove(board.id) ?? [];

    for (final list in lists) {
      _tasksByList.remove(list.id);
    }

    _selectedBoard = _boards.isEmpty ? null : _boards.first;

    notifyListeners();

    if (_selectedBoard != null) {
      await loadBoardData(_selectedBoard!);
    }
  }

  Future<void> createList(String name, Board board) async {
    final list = await _api.createList(name, board.id);

    _listsByBoard.putIfAbsent(board.id, () => []);
    _listsByBoard[board.id]!.add(list);

    _tasksByList[list.id] = [];

    notifyListeners();
  }

  Future<void> deleteList(TaskList list) async {
    await _api.deleteList(list.id);

    for (final lists in _listsByBoard.values) {
      lists.removeWhere((item) => item.id == list.id);
    }

    _tasksByList.remove(list.id);

    notifyListeners();
  }

  Future<void> createTask(
    String title, {
    String? description,
    required TaskList list,
  }) async {
    final task = await _api.createTask(
      title,
      description: description,
      listId: list.id,
    );

    _tasksByList.putIfAbsent(list.id, () => []);
    _tasksByList[list.id]!.add(task);

    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    final updated = await _api.updateTask(task);

    _replaceTask(updated);
  }

  Future<void> toggleTask(Task task, bool completed) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      completed: completed,
      listId: task.listId,
    );

    final updated = await _api.updateTask(updatedTask);

    _replaceTask(updated);
  }

  Future<void> deleteTask(Task task) async {
    await _api.deleteTask(task.id);

    for (final tasks in _tasksByList.values) {
      tasks.removeWhere((item) => item.id == task.id);
    }

    notifyListeners();
  }

  void _replaceTask(Task updated) {
    for (final tasks in _tasksByList.values) {
      final index = tasks.indexWhere((item) => item.id == updated.id);

      if (index != -1) {
        tasks[index] = updated;
      }
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }
}
