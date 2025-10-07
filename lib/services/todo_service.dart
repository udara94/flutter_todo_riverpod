import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../entity/todo.dart';

class TodoService {
  static const String _todosKey = 'todos_data';
  static SharedPreferences? _prefs;
  static final _uuid = const Uuid();
  static final _todoController = StreamController<List<Todo>>.broadcast();

  static void initialize(SharedPreferences prefs) {
    _prefs = prefs;
  }

  // Stream for real-time todo updates
  static Stream<List<Todo>> get todosStream => _todoController.stream;

  static Future<List<Todo>> getTodos(String userId) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay

    final todosJson = _prefs!.getString('${_todosKey}_$userId');
    debugPrint('TodoService.getTodos: Loading todos for user $userId');
    debugPrint('TodoService.getTodos: Found data: ${todosJson != null}');

    if (todosJson == null) {
      // Create some mock todos for demo
      debugPrint('TodoService.getTodos: No existing data, creating mock todos');
      final mockTodos = _createMockTodos(userId);
      await _saveTodos(userId, mockTodos);
      return mockTodos;
    }

    try {
      final List<dynamic> todosList = jsonDecode(todosJson);
      final todos = todosList.map((json) => Todo.fromJson(json)).toList();
      debugPrint(
        'TodoService.getTodos: Loaded ${todos.length} todos from storage',
      );
      return todos;
    } catch (e) {
      debugPrint('TodoService.getTodos: Error parsing todos: $e');
      return [];
    }
  }

  static Future<Todo> createTodo({
    required String title,
    required String description,
    required TodoPriority priority,
    required String userId,
    DateTime? dueDate,
    List<String> tags = const [],
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));

    // Simulate random failures
    if (Random().nextDouble() < 0.05) {
      throw TodoException('Failed to create todo. Please try again.');
    }

    final todo = Todo(
      id: _uuid.v4(),
      title: title,
      description: description,
      priority: priority,
      status: TodoStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      dueDate: dueDate,
      tags: tags.join(','),
      userId: userId,
    );

    final todos = await getTodos(userId);
    final updatedTodos = [...todos, todo];
    await _saveTodos(userId, updatedTodos);
    _todoController.add(updatedTodos);

    return todo;
  }

  static Future<Todo> updateTodo(Todo todo) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final updatedTodo = todo.copyWith(updatedAt: DateTime.now());
    final todos = await getTodos(todo.userId);
    final updatedTodos = todos
        .map((t) => t.id == todo.id ? updatedTodo : t)
        .toList();
    await _saveTodos(todo.userId, updatedTodos);
    _todoController.add(updatedTodos);

    return updatedTodo;
  }

  static Future<void> deleteTodo(String todoId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final todos = await getTodos(userId);
    final updatedTodos = todos.where((t) => t.id != todoId).toList();
    await _saveTodos(userId, updatedTodos);
    _todoController.add(updatedTodos);
  }

  Future<List<Todo>> searchTodos(String userId, String query) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final todos = await getTodos(userId);
    if (query.isEmpty) return todos;

    return todos.where((todo) {
      return todo.title.toLowerCase().contains(query.toLowerCase()) ||
          todo.description.toLowerCase().contains(query.toLowerCase()) ||
          (todo.tags
                  ?.split(',')
                  .any(
                    (tag) =>
                        tag.trim().toLowerCase().contains(query.toLowerCase()),
                  ) ??
              false);
    }).toList();
  }

  Future<List<Todo>> getTodosByStatus(String userId, TodoStatus status) async {
    final todos = await getTodos(userId);
    return todos.where((todo) => todo.status == status).toList();
  }

  Future<List<Todo>> getTodosByPriority(
    String userId,
    TodoPriority priority,
  ) async {
    final todos = await getTodos(userId);
    return todos.where((todo) => todo.priority == priority).toList();
  }

  Future<List<Todo>> getOverdueTodos(String userId) async {
    final todos = await getTodos(userId);
    final now = DateTime.now();
    return todos.where((todo) {
      return todo.dueDate != null &&
          todo.dueDate!.isBefore(now) &&
          todo.status != TodoStatus.completed;
    }).toList();
  }

  static Future<void> _saveTodos(String userId, List<Todo> todos) async {
    final todosJson = jsonEncode(todos.map((todo) => todo.toJson()).toList());
    await _prefs!.setString('${_todosKey}_$userId', todosJson);
    debugPrint(
      'TodoService._saveTodos: Saved ${todos.length} todos for user $userId',
    );
  }

  static List<Todo> _createMockTodos(String userId) {
    final now = DateTime.now();
    return [
      Todo(
        id: _uuid.v4(),
        title: 'Complete Riverpod Article',
        description:
            'Write comprehensive article about Flutter Riverpod state management with examples',
        priority: TodoPriority.high,
        status: TodoStatus.inProgress,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
        dueDate: now.add(const Duration(days: 3)),
        tags: 'work,flutter,article',
        userId: userId,
      ),
      Todo(
        id: _uuid.v4(),
        title: 'Implement Authentication',
        description:
            'Add login/logout functionality with proper state management',
        priority: TodoPriority.high,
        status: TodoStatus.completed,
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 1)),
        dueDate: now.subtract(const Duration(days: 1)),
        tags: 'auth,flutter,riverpod',
        userId: userId,
      ),
      Todo(
        id: _uuid.v4(),
        title: 'Add Dark Mode Support',
        description: 'Implement theme switching with persistence',
        priority: TodoPriority.medium,
        status: TodoStatus.pending,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
        dueDate: now.add(const Duration(days: 7)),
        tags: 'ui,theme,accessibility',
        userId: userId,
      ),
      Todo(
        id: _uuid.v4(),
        title: 'Write Unit Tests',
        description:
            'Add comprehensive test coverage for all providers and services',
        priority: TodoPriority.medium,
        status: TodoStatus.pending,
        createdAt: now.subtract(const Duration(hours: 12)),
        updatedAt: now.subtract(const Duration(hours: 12)),
        dueDate: now.add(const Duration(days: 5)),
        tags: 'testing,quality',
        userId: userId,
      ),
      Todo(
        id: _uuid.v4(),
        title: 'Optimize Performance',
        description: 'Implement lazy loading and performance optimizations',
        priority: TodoPriority.low,
        status: TodoStatus.pending,
        createdAt: now.subtract(const Duration(hours: 6)),
        updatedAt: now.subtract(const Duration(hours: 6)),
        dueDate: now.add(const Duration(days: 10)),
        tags: 'performance,optimization',
        userId: userId,
      ),
    ];
  }

  void dispose() {
    _todoController.close();
  }
}

class TodoException implements Exception {
  final String message;
  const TodoException(this.message);

  @override
  String toString() => 'TodoException: $message';
}
