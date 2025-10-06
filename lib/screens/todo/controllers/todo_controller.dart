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
