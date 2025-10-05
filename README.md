# Flutter Riverpod Advanced State Management Demo

This Flutter application demonstrates **Flutter Riverpod** as an advanced state management library through a comprehensive Todo App with User Authentication. The app showcases all major Riverpod features and patterns used in production applications.

## 🚀 Features Implemented

### Core Provider Types

- **Provider** - Immutable values (app configuration, constants)
- **StateProvider** - Simple state (theme toggle, filter selection)
- **StateNotifierProvider** - Complex state management (todo list, cart)
- **FutureProvider** - Async operations (API calls, database queries)
- **StreamProvider** - Real-time data (WebSocket, Firebase streams)

### Provider Modifiers

- **Family** - Parameterized providers (fetch user by ID)
- **AutoDispose** - Automatic cleanup when no longer used
- **Family + AutoDispose** - Combined for optimal resource management

### Reading Providers

- **ref.watch** - Listen to changes in build method
- **ref.read** - One-time read in event handlers
- **ref.listen** - Side effects (navigation, snackbars, dialogs)
- **ref.invalidate** - Force provider refresh

### Consumer Widgets

- **ConsumerWidget** - Replacing StatelessWidget
- **ConsumerStatefulWidget** - With lifecycle methods
- **Consumer** - Localized rebuilds for optimization

### Advanced Features

- **Provider Composition** - Combining multiple providers
- **Computed/Derived State** - Filtering, sorting, transformations
- **Provider Dependencies** - Watching other providers
- **ProviderScope** - Multiple scopes for testing/isolation
- **ProviderObserver** - Logging state changes
- **ref.onDispose** - Resource cleanup

### Async Handling

- **AsyncValue.when** - Handle loading/error/data states
- **AsyncValue.maybeWhen** - Partial state handling
- **RefreshIndicator** - Pull to refresh with providers
- **Manual refresh** - Using ref.refresh()

### State Management Patterns

- **Immutable State** - Using copyWith
- **List Operations** - Add, remove, update items
- **Form State Management** - Multi-field forms
- **Pagination** - Loading more data
- **Search/Filter** - Real-time filtering
- **Debouncing** - Search with delay

### Error Handling

- **Error States** - Graceful error UI
- **Retry Logic** - Retry failed operations
- **Error Boundaries** - Catching provider errors

### Performance Optimization

- **select()** - Subscribe to partial state
- **Provider Granularity** - Splitting providers correctly
- **Lazy Loading** - Loading data on demand

### Testing Features

- **Provider Overrides** - Mocking for tests
- **Integration Testing** - End-to-end with Riverpod

### Real-World Scenarios

- **Authentication Flow** - Login/logout state
- **API Integration** - REST API calls
- **Local Storage** - SharedPreferences integration
- **Caching Strategy** - Cache and refresh pattern
- **Optimistic Updates** - Update UI before API confirms
- **Global State** - App-wide settings
- **Navigation with State** - Go Router integration
- **Multi-step Forms** - Wizard-style forms

## 📱 App Structure

```
lib/
├── main.dart                          # App entry point with ProviderScope
├── models/                           # Data models
│   ├── user.dart                     # User model with JSON serialization
│   ├── todo.dart                     # Todo model with enums
│   └── auth_state.dart               # Authentication state model
├── services/                         # Business logic services
│   ├── auth_service.dart             # Authentication service
│   └── todo_service.dart             # Todo CRUD service
├── providers/                        # Riverpod providers
│   └── providers.dart                # All provider definitions
└── screens/                          # UI screens
    ├── auth/
    │   └── login_screen.dart         # Login/logout functionality
    ├── todo/
    │   ├── home_screen.dart          # Todo list with filtering/search
    │   └── add_edit_todo_screen.dart # Todo creation/editing
    ├── stats/
    │   └── todo_stats_screen.dart    # Statistics and analytics
    └── demo/
        └── riverpod_demo_screen.dart # Interactive Riverpod demo
```

## 🎯 Key Riverpod Concepts Demonstrated

### 1. Provider Types and Their Use Cases

```dart
// Provider - Immutable values
final appConfigProvider = Provider<AppConfig>((ref) {
  return const AppConfig(appName: 'Riverpod Todo App');
});

// StateProvider - Simple state
final darkModeProvider = StateProvider<bool>((ref) => false);

// StateNotifierProvider - Complex state
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

// FutureProvider - Async operations
final currentUserProvider = FutureProvider<User?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return authService.getCurrentUser();
});

// StreamProvider - Real-time data
final authStateStreamProvider = StreamProvider<AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateStream;
});
```

### 2. Provider Modifiers

```dart
// Family modifier - Parameterized providers
final userProfileProvider = FutureProvider.family<User?, String>((ref, userId) async {
  // Fetch user by ID
});

// AutoDispose modifier - Automatic cleanup
final temporaryDataProvider = Provider.autoDispose<String>((ref) {
  ref.onDispose(() => print('Disposed'));
  return 'Temporary data';
});

// Combined modifiers
final userSpecificDataProvider = Provider.autoDispose.family<String, String>((ref, userId) {
  ref.onDispose(() => print('Disposed for user: $userId'));
  return 'Data for $userId';
});
```

### 3. Provider Composition

```dart
// Computed state from multiple providers
final filteredTodosProvider = Provider.family<List<Todo>, String>((ref, userId) {
  final todos = ref.watch(todoListProvider(userId));
  final searchQuery = ref.watch(searchQueryProvider);
  final selectedFilter = ref.watch(selectedFilterProvider);

  return todos.where((todo) {
    // Apply filters and search
  }).toList();
});
```

### 4. Performance Optimizations

```dart
// Select method for partial state subscription
final todoCountProvider = Provider.family<int, String>((ref, userId) {
  return ref.watch(todoListProvider(userId).select((todos) => todos.length));
});

// Lazy loading
final lazyDataProvider = FutureProvider.autoDispose<String>((ref) async {
  await Future.delayed(const Duration(seconds: 2));
  return 'Lazy loaded data';
});
```

### 5. Error Handling

```dart
// AsyncValue handling
final todoStats = ref.watch(todoStatsProvider(userId));
todoStats.when(
  data: (stats) => Text('Total: ${stats.total}'),
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => Text('Error: $error'),
);
```

## 🛠️ Getting Started

1. **Install dependencies:**

   ```bash
   flutter pub get
   ```

2. **Generate JSON serialization code:**

   ```bash
   flutter packages pub run build_runner build
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## 🎮 Demo Credentials

Use these credentials to test the authentication:

- **Email:** demo@example.com
- **Password:** password123

## 📚 Learning Resources

This app demonstrates:

1. **State Management Patterns** - How to structure state in a Flutter app
2. **Provider Architecture** - Different types of providers and their use cases
3. **Performance Optimization** - Using select(), autoDispose, and lazy loading
4. **Error Handling** - Graceful error states and retry mechanisms
5. **Real-world Scenarios** - Authentication, CRUD operations, filtering, search
6. **Testing Strategies** - Provider overrides and mocking

## 🔧 Customization

The app is designed to be easily customizable:

- **Add new provider types** in `lib/providers/providers.dart`
- **Extend models** in `lib/models/`
- **Add new screens** following the existing pattern
- **Implement real API calls** by replacing mock services

## 📖 Article Content

This app serves as a comprehensive example for an article about Flutter Riverpod as an advanced state management library, demonstrating:

- All core provider types with real-world examples
- Advanced patterns and best practices
- Performance optimization techniques
- Error handling strategies
- Testing approaches
- Production-ready architecture

The codebase is well-documented and follows Flutter/Dart best practices, making it an excellent reference for developers learning Riverpod.
