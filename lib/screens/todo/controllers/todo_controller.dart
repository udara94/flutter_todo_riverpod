import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_app/entity/todo.dart';
import 'package:todo_app/services/todo_service.dart';
import '../state/todo_state.dart';

part 'todo_controller.g.dart';

@riverpod
class TodoController extends _$TodoController {
  @override
  TodoState build() {
    return TodoState();
  }

  Future<void> loadTodos(String userId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final todos = await TodoService.getTodos(userId);
      state = state.copyWith(todos: todos, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        lastErrorTime: DateTime.now(),
      );
    }
  }

  Future<void> addTodo({
    required String title,
    required String description,
    required TodoPriority priority,
    required String userId,
    DateTime? dueDate,
    List<String> tags = const [],
  }) async {
    try {
      final todo = await TodoService.createTodo(
        title: title,
        description: description,
        priority: priority,
        userId: userId,
        dueDate: dueDate,
        tags: tags,
      );

      state = state.copyWith(todos: [...state.todos, todo]);
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        lastErrorTime: DateTime.now(),
      );
      rethrow;
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      final updatedTodo = await TodoService.updateTodo(todo);
      state = state.copyWith(
        todos: state.todos
            .map((t) => t.id == todo.id ? updatedTodo : t)
            .toList(),
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        lastErrorTime: DateTime.now(),
      );
      rethrow;
    }
  }

  Future<void> deleteTodo(String todoId, String userId) async {
    try {
      await TodoService.deleteTodo(todoId, userId);
      state = state.copyWith(
        todos: state.todos.where((t) => t.id != todoId).toList(),
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        lastErrorTime: DateTime.now(),
      );
      rethrow;
    }
  }

  Future<void> toggleTodoStatus(String todoId) async {
    final todo = state.todos.firstWhere((t) => t.id == todoId);
    final newStatus = todo.status == TodoStatus.completed
        ? TodoStatus.pending
        : TodoStatus.completed;

    final updatedTodo = todo.copyWith(status: newStatus);
    await updateTodo(updatedTodo);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setStatusFilter(TodoStatus? status) {
    state = state.copyWith(
      selectedStatusFilter: status,
      selectedPriorityFilter:
          null, // Clear priority filter when status is selected
    );
  }

  void setPriorityFilter(TodoPriority? priority) {
    state = state.copyWith(
      selectedPriorityFilter: priority,
      selectedStatusFilter:
          null, // Clear status filter when priority is selected
    );
  }

  void setSortOrder(SortOrder order) {
    state = state.copyWith(sortOrder: order);
  }

  void clearFilters() {
    state = state.copyWith(
      selectedStatusFilter: null,
      selectedPriorityFilter: null,
      searchQuery: '',
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null, lastErrorTime: null);
  }

  Future<({int successCount, int totalCount, String? error})> addTestTodos(
    String userId,
  ) async {
    try {
      // Create test todos with different statuses and priorities
      final testTodos = [
        // High Priority - Pending
        {
          'title': 'Critical Bug Fix',
          'description': 'Fix the authentication issue in the login screen',
          'priority': TodoPriority.high,
          'status': TodoStatus.pending,
          'dueDate': DateTime.now().add(const Duration(days: 1)),
          'tags': 'bug,urgent,frontend',
        },
        // High Priority - In Progress
        {
          'title': 'Database Migration',
          'description': 'Migrate user data to new schema',
          'priority': TodoPriority.high,
          'status': TodoStatus.inProgress,
          'dueDate': DateTime.now().add(const Duration(days: 2)),
          'tags': 'database,migration,backend',
        },
        // High Priority - Completed
        {
          'title': 'API Documentation',
          'description': 'Complete REST API documentation',
          'priority': TodoPriority.high,
          'status': TodoStatus.completed,
          'dueDate': DateTime.now().subtract(const Duration(days: 1)),
          'tags': 'documentation,api,completed',
        },
        // Medium Priority - Pending
        {
          'title': 'UI/UX Improvements',
          'description': 'Enhance user interface based on feedback',
          'priority': TodoPriority.medium,
          'status': TodoStatus.pending,
          'dueDate': DateTime.now().add(const Duration(days: 3)),
          'tags': 'ui,ux,improvement',
        },
        // Medium Priority - In Progress
        {
          'title': 'Performance Optimization',
          'description': 'Optimize app performance and reduce load times',
          'priority': TodoPriority.medium,
          'status': TodoStatus.inProgress,
          'dueDate': DateTime.now().add(const Duration(days: 4)),
          'tags': 'performance,optimization',
        },
        // Medium Priority - Completed
        {
          'title': 'Code Review',
          'description': 'Review pull requests from team members',
          'priority': TodoPriority.medium,
          'status': TodoStatus.completed,
          'dueDate': DateTime.now().subtract(const Duration(days: 2)),
          'tags': 'review,code,completed',
        },
        // Low Priority - Pending
        {
          'title': 'Update Dependencies',
          'description': 'Update all project dependencies to latest versions',
          'priority': TodoPriority.low,
          'status': TodoStatus.pending,
          'dueDate': DateTime.now().add(const Duration(days: 7)),
          'tags': 'dependencies,maintenance',
        },
        // Low Priority - In Progress
        {
          'title': 'Write Unit Tests',
          'description': 'Add comprehensive unit tests for new features',
          'priority': TodoPriority.low,
          'status': TodoStatus.inProgress,
          'dueDate': DateTime.now().add(const Duration(days: 5)),
          'tags': 'testing,unit-tests',
        },
        // Low Priority - Completed
        {
          'title': 'Update README',
          'description': 'Update project README with latest information',
          'priority': TodoPriority.low,
          'status': TodoStatus.completed,
          'dueDate': DateTime.now().subtract(const Duration(days: 3)),
          'tags': 'documentation,readme,completed',
        },
        // Overdue - High Priority
        {
          'title': 'Security Audit',
          'description': 'Conduct security audit of the application',
          'priority': TodoPriority.high,
          'status': TodoStatus.pending,
          'dueDate': DateTime.now().subtract(const Duration(days: 2)),
          'tags': 'security,audit,overdue',
        },
        // Overdue - Medium Priority
        {
          'title': 'Client Meeting Prep',
          'description': 'Prepare materials for client presentation',
          'priority': TodoPriority.medium,
          'status': TodoStatus.inProgress,
          'dueDate': DateTime.now().subtract(const Duration(days: 1)),
          'tags': 'meeting,client,overdue',
        },
        // Future Task
        {
          'title': 'Feature Planning',
          'description': 'Plan new features for next sprint',
          'priority': TodoPriority.low,
          'status': TodoStatus.pending,
          'dueDate': DateTime.now().add(const Duration(days: 14)),
          'tags': 'planning,features,future',
        },
      ];

      // Add each test todo with retry logic
      int successCount = 0;
      for (final todoData in testTodos) {
        bool success = false;
        int retryCount = 0;
        const maxRetries = 3;

        while (!success && retryCount < maxRetries) {
          try {
            // First add the todo (it will be created with pending status)
            await addTodo(
              title: todoData['title'] as String,
              description: todoData['description'] as String,
              priority: todoData['priority'] as TodoPriority,
              dueDate: todoData['dueDate'] as DateTime?,
              tags: (todoData['tags'] as String).split(','),
              userId: userId,
            );

            // Then update the status if it's not pending
            final targetStatus = todoData['status'] as TodoStatus;
            if (targetStatus != TodoStatus.pending) {
              // Get the current state and find the last added todo
              final lastTodo = state.todos.last;
              final updatedTodo = lastTodo.copyWith(status: targetStatus);
              await updateTodo(updatedTodo);
            }

            success = true;
            successCount++;
          } catch (e) {
            retryCount++;
            if (retryCount >= maxRetries) {
              // If all retries failed, log the error but continue with other todos
              print(
                'Failed to create todo "${todoData['title']}" after $maxRetries retries: $e',
              );
            } else {
              // Wait a bit before retrying
              await Future.delayed(const Duration(milliseconds: 100));
            }
          }
        }
      }

      return (
        successCount: successCount,
        totalCount: testTodos.length,
        error: null,
      );
    } catch (e) {
      return (successCount: 0, totalCount: 0, error: e.toString());
    }
  }

  List<Todo> get filteredTodos {
    var filteredTodos = List<Todo>.from(state.todos);

    // Apply search filter
    if (state.searchQuery.isNotEmpty) {
      filteredTodos = filteredTodos.where((todo) {
        return todo.title.toLowerCase().contains(
              state.searchQuery.toLowerCase(),
            ) ||
            todo.description.toLowerCase().contains(
              state.searchQuery.toLowerCase(),
            ) ||
            (todo.tags
                    ?.split(',')
                    .any(
                      (tag) => tag.trim().toLowerCase().contains(
                        state.searchQuery.toLowerCase(),
                      ),
                    ) ??
                false);
      }).toList();
    }

    // Apply status filter
    if (state.selectedStatusFilter != null) {
      filteredTodos = filteredTodos
          .where((todo) => todo.status == state.selectedStatusFilter)
          .toList();
    }

    // Apply priority filter
    if (state.selectedPriorityFilter != null) {
      filteredTodos = filteredTodos
          .where((todo) => todo.priority == state.selectedPriorityFilter)
          .toList();
    }

    // Apply sorting
    switch (state.sortOrder) {
      case SortOrder.createdAtAsc:
        filteredTodos.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SortOrder.createdAtDesc:
        filteredTodos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOrder.titleAsc:
        filteredTodos.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortOrder.titleDesc:
        filteredTodos.sort((a, b) => b.title.compareTo(a.title));
        break;
      case SortOrder.priorityAsc:
        filteredTodos.sort(
          (a, b) => a.priority.index.compareTo(b.priority.index),
        );
        break;
      case SortOrder.priorityDesc:
        filteredTodos.sort(
          (a, b) => b.priority.index.compareTo(a.priority.index),
        );
        break;
    }

    return filteredTodos;
  }
}
