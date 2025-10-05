import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../services/todo_service.dart';
import '../models/user.dart';
import '../models/todo.dart';
import '../models/auth_state.dart';

// ============================================================================
// SERVICE PROVIDERS - Provider (Immutable values)
// ============================================================================

/// Provider for SharedPreferences - immutable configuration
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden');
});

/// Provider for AuthService - immutable service
final authServiceProvider = Provider<AuthService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthService(prefs);
});

/// Provider for TodoService - immutable service
final todoServiceProvider = Provider<TodoService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return TodoService(prefs);
});

// ============================================================================
// APP CONFIGURATION PROVIDERS - Provider (Constants)
// ============================================================================

/// App configuration provider - immutable values
final appConfigProvider = Provider<AppConfig>((ref) {
  return const AppConfig(
    appName: 'Riverpod Todo App',
    version: '1.0.0',
    apiBaseUrl: 'https://jsonplaceholder.typicode.com',
    maxTodosPerUser: 100,
    enableOfflineMode: true,
  );
});

class AppConfig {
  final String appName;
  final String version;
  final String apiBaseUrl;
  final int maxTodosPerUser;
  final bool enableOfflineMode;

  const AppConfig({
    required this.appName,
    required this.version,
    required this.apiBaseUrl,
    required this.maxTodosPerUser,
    required this.enableOfflineMode,
  });
}

// ============================================================================
// THEME PROVIDERS - StateProvider (Simple state)
// ============================================================================

/// Dark mode toggle - simple state management
final darkModeProvider = StateProvider<bool>((ref) => false);

/// Selected filter - simple state management
final selectedFilterProvider = StateProvider<TodoStatus?>((ref) => null);

/// Search query - simple state management with debouncing
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Selected priority filter - simple state management
final selectedPriorityProvider = StateProvider<TodoPriority?>((ref) => null);

/// Sort order - simple state management
final sortOrderProvider = StateProvider<SortOrder>(
      (ref) => SortOrder.createdAtDesc,
);

enum SortOrder {
  createdAtAsc,
  createdAtDesc,
  titleAsc,
  titleDesc,
  priorityAsc,
  priorityDesc,
}

// ============================================================================
// AUTHENTICATION PROVIDERS - StateNotifierProvider (Complex state)
// ============================================================================

/// Auth state notifier for complex authentication state management
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authService) : super(const AuthState.initial()) {
    _initialize();
  }

  final AuthService _authService;

  Future<void> _initialize() async {
    state = const AuthState.loading();
    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(e.toString(), DateTime.now());
    }
  }

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    try {
      final user = await _authService.login(email, password);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString(), DateTime.now());
    }
  }

  Future<void> logout() async {
    state = const AuthState.loading();
    try {
      await _authService.logout();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString(), DateTime.now());
    }
  }

  Future<void> refreshUser() async {
    if (state.isAuthenticated) {
      try {
        await _authService.refreshUser();
        final user = await _authService.getCurrentUser();
        if (user != null) {
          state = AuthState.authenticated(user);
        }
      } catch (e) {
        state = AuthState.error(e.toString(), DateTime.now());
      }
    }
  }

  void clearError() {
    if (state.hasError) {
      state = const AuthState.unauthenticated();
    }
  }
}

/// Auth state provider - complex state management
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

// ============================================================================
// TODO PROVIDERS - StateNotifierProvider (Complex state)
// ============================================================================

/// Todo state notifier for complex todo state management
class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier(this._todoService, this._userId) : super([]) {
    _loadTodos();
  }

  final TodoService _todoService;
  final String _userId;

  Future<void> _loadTodos() async {
    try {
      final todos = await _todoService.getTodos(_userId);
      state = todos;
    } catch (e) {
      // Handle error - could emit error state
      state = [];
    }
  }

  Future<void> addTodo({
    required String title,
    required String description,
    required TodoPriority priority,
    DateTime? dueDate,
    List<String> tags = const [],
  }) async {
    try {
      final todo = await _todoService.createTodo(
        title: title,
        description: description,
        priority: priority,
        userId: _userId,
        dueDate: dueDate,
        tags: tags,
      );
      state = [...state, todo];
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      final updatedTodo = await _todoService.updateTodo(todo);
      state = state.map((t) => t.id == todo.id ? updatedTodo : t).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTodo(String todoId) async {
    try {
      await _todoService.deleteTodo(todoId, _userId);
      state = state.where((t) => t.id != todoId).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleTodoStatus(String todoId) async {
    final todo = state.firstWhere((t) => t.id == todoId);
    final newStatus = todo.status == TodoStatus.completed
        ? TodoStatus.pending
        : TodoStatus.completed;

    final updatedTodo = todo.copyWith(status: newStatus);
    await updateTodo(updatedTodo);
  }

  Future<void> refreshTodos() async {
    await _loadTodos();
  }
}

/// Todo list provider - complex state management
final todoListProvider =
StateNotifierProvider.family<TodoNotifier, List<Todo>, String>((
    ref,
    userId,
    ) {
  final todoService = ref.watch(todoServiceProvider);
  return TodoNotifier(todoService, userId);
});

// ============================================================================
// ASYNC PROVIDERS - FutureProvider (Async operations)
// ============================================================================

/// Current user provider - async operation
final currentUserProvider = FutureProvider<User?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return authService.getCurrentUser();
});

/// User profile provider with family - parameterized async operation
final userProfileProvider = FutureProvider.family<User?, String>((
    ref,
    userId,
    ) async {
  final authService = ref.watch(authServiceProvider);
  // In a real app, this would fetch user profile by ID
  return authService.getCurrentUser();
});

/// Todo statistics provider - async computed data
final todoStatsProvider = FutureProvider.family<TodoStats, String>((
    ref,
    userId,
    ) async {
  final todoService = ref.watch(todoServiceProvider);
  final todos = await todoService.getTodos(userId);

  return TodoStats(
    total: todos.length,
    completed: todos.where((t) => t.status == TodoStatus.completed).length,
    pending: todos.where((t) => t.status == TodoStatus.pending).length,
    inProgress: todos.where((t) => t.status == TodoStatus.inProgress).length,
    overdue: todos
        .where(
          (t) =>
      t.dueDate != null &&
          t.dueDate!.isBefore(DateTime.now()) &&
          t.status != TodoStatus.completed,
    )
        .length,
  );
});

class TodoStats {
  final int total;
  final int completed;
  final int pending;
  final int inProgress;
  final int overdue;

  const TodoStats({
    required this.total,
    required this.completed,
    required this.pending,
    required this.inProgress,
    required this.overdue,
  });
}

// ============================================================================
// STREAM PROVIDERS - StreamProvider (Real-time data)
// ============================================================================

/// Auth state stream provider - real-time authentication state
final authStateStreamProvider = StreamProvider<AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateStream;
});

/// Todo stream provider - real-time todo updates
final todoStreamProvider = StreamProvider.family<List<Todo>, String>((
    ref,
    userId,
    ) {
  final todoService = ref.watch(todoServiceProvider);
  return todoService.todosStream;
});

// ============================================================================
// COMPUTED/DERIVED STATE PROVIDERS
// ============================================================================

/// Filtered todos provider - computed state based on multiple providers
final filteredTodosProvider = Provider.family<List<Todo>, String>((
    ref,
    userId,
    ) {
  final todos = ref.watch(todoListProvider(userId));
  final searchQuery = ref.watch(searchQueryProvider);
  final selectedFilter = ref.watch(selectedFilterProvider);
  final selectedPriority = ref.watch(selectedPriorityProvider);
  final sortOrder = ref.watch(sortOrderProvider);

  var filteredTodos = todos;

  // Apply search filter
  if (searchQuery.isNotEmpty) {
    filteredTodos = filteredTodos.where((todo) {
      return todo.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          todo.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
          todo.tags.any(
                (tag) => tag.toLowerCase().contains(searchQuery.toLowerCase()),
          );
    }).toList();
  }

  // Apply status filter
  if (selectedFilter != null) {
    filteredTodos = filteredTodos
        .where((todo) => todo.status == selectedFilter)
        .toList();
  }

  // Apply priority filter
  if (selectedPriority != null) {
    filteredTodos = filteredTodos
        .where((todo) => todo.priority == selectedPriority)
        .toList();
  }

  // Apply sorting
  switch (sortOrder) {
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
});

/// Search suggestions provider - computed from search query
final searchSuggestionsProvider = Provider<List<String>>((ref) {
  final searchQuery = ref.watch(searchQueryProvider);
  if (searchQuery.isEmpty) return [];

  // Mock suggestions based on common todo terms
  const suggestions = [
    'work',
    'personal',
    'urgent',
    'important',
    'meeting',
    'deadline',
    'project',
    'review',
    'plan',
    'schedule',
  ];

  return suggestions
      .where(
        (suggestion) =>
        suggestion.toLowerCase().contains(searchQuery.toLowerCase()),
  )
      .toList();
});

// ============================================================================
// PROVIDER MODIFIERS - Family + AutoDispose
// ============================================================================

/// Auto-dispose provider for temporary data
final temporaryDataProvider = Provider.autoDispose<String>((ref) {
  ref.onDispose(() {
    print('Temporary data disposed');
  });
  return 'Temporary data that will be disposed when not used';
});

/// Family + AutoDispose provider for optimal resource management
final userSpecificDataProvider = Provider.autoDispose.family<String, String>((
    ref,
    userId,
    ) {
  ref.onDispose(() {
    print('User specific data disposed for user: $userId');
  });
  return 'Data specific to user: $userId';
});

// ============================================================================
// ERROR HANDLING PROVIDERS
// ============================================================================

/// Error state provider for global error handling
final errorStateProvider = StateProvider<String?>((ref) => null);

/// Retry mechanism provider
final retryCountProvider = StateProvider<int>((ref) => 0);

// ============================================================================
// PERFORMANCE OPTIMIZATION PROVIDERS
// ============================================================================

/// Select provider for partial state subscription
final todoCountProvider = Provider.family<int, String>((ref, userId) {
  return ref.watch(todoListProvider(userId).select((todos) => todos.length));
});

/// Lazy loading provider
final lazyDataProvider = FutureProvider.autoDispose<String>((ref) async {
  await Future.delayed(const Duration(seconds: 2)); // Simulate loading
  return 'Lazy loaded data';
});
