import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/board.dart';
import '../models/task_list.dart';
import '../models/task.dart';

class TaskApi {
  static const String baseUrl = 'http://192.168.100.65:8000';

  final http.Client _client = http.Client();

  void _checkResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Erro HTTP ${response.statusCode}: ${response.body}');
    }
  }

  Future<List<Board>> getBoards() async {
    final response = await _client
        .get(Uri.parse('$baseUrl/boards'))
        .timeout(const Duration(seconds: 10));

    _checkResponse(response);

    final data = jsonDecode(response.body) as List<dynamic>;

    return data
        .map((item) => Board.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  
Future<Board> createBoard(String name, {String type = 'tarefas'}) async {
  final response = await _client
      .post(
        Uri.parse('$baseUrl/boards'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nome': name,
          'tipo': type,
        }),
      )
      .timeout(const Duration(seconds: 10));

  _checkResponse(response);

  return Board.fromJson(
    jsonDecode(response.body) as Map<String, dynamic>,
  );
}


  Future<void> deleteBoard(int boardId) async {
    final response = await _client
        .delete(Uri.parse('$baseUrl/boards/$boardId'))
        .timeout(const Duration(seconds: 10));

    _checkResponse(response);
  }

  // ==========================================================
  // LISTAS
  // ==========================================================

  Future<List<TaskList>> getLists(int boardId) async {
    final response = await _client
        .get(Uri.parse('$baseUrl/boards/$boardId/lists'))
        .timeout(const Duration(seconds: 10));

    _checkResponse(response);

    final data = jsonDecode(response.body) as List<dynamic>;

    return data
        .map((item) => TaskList.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<TaskList> createList(String name, int boardId) async {
    final response = await _client
        .post(
          Uri.parse('$baseUrl/lists'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'nome': name, 'quadro_id': boardId}),
        )
        .timeout(const Duration(seconds: 10));

    _checkResponse(response);
    return TaskList.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> deleteList(int listId) async {
    final response = await _client
        .delete(Uri.parse('$baseUrl/lists/$listId'))
        .timeout(const Duration(seconds: 10));

    _checkResponse(response);
  }

  // ==========================================================
  // TAREFAS
  // ==========================================================

  Future<List<Task>> getTasks() async {
    final response = await _client
        .get(Uri.parse('$baseUrl/tasks'))
        .timeout(const Duration(seconds: 10));

    _checkResponse(response);

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    final items = data['tarefas'] as List<dynamic>;

    return items
        .map((item) => Task.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Task>> getTasksFromList(int listId) async {
    final response = await _client
        .get(Uri.parse('$baseUrl/lists/$listId/tasks'))
        .timeout(const Duration(seconds: 10));

    _checkResponse(response);

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    final items = data['tarefas'] as List<dynamic>;

    return items
        .map((item) => Task.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Task> createTask(
    String title, {
    String? description,
    int? listId,
  }) async {
    final response = await _client
        .post(
          Uri.parse('$baseUrl/tasks'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'titulo': title,
            'descricao': description,
            'lista_id': listId,
          }),
        )
        .timeout(const Duration(seconds: 10));

    _checkResponse(response);

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    return Task.fromJson(data['tarefa'] as Map<String, dynamic>);
  }

  Future<Task> updateTask(Task task) async {
    final response = await _client
        .put(
          Uri.parse('$baseUrl/tasks/${task.id}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(task.toUpdateJson()),
        )
        .timeout(const Duration(seconds: 10));

    _checkResponse(response);

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    return Task.fromJson(data['tarefa'] as Map<String, dynamic>);
  }

  Future<void> deleteTask(int id) async {
    final response = await _client
        .delete(Uri.parse('$baseUrl/tasks/$id'))
        .timeout(const Duration(seconds: 10));

    _checkResponse(response);
  }

  // ==========================================================
  // ENCERRAMENTO
  // ==========================================================

  void dispose() {
    _client.close();
  }
}
