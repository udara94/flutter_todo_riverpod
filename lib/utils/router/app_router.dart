import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/auth/views/login_screen.dart';
import '../../screens/todo/views/home_screen.dart';
import '../../screens/todo/views/add_edit_todo_screen.dart';
import '../../screens/stats/views/todo_stats_screen.dart';

/// Centralized router configuration for the Todo App
class AppRouter {
  // Route path constants
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String addTodo = '/add-todo';
  static const String editTodo = '/edit-todo';
  static const String stats = '/stats';

  // Route name constants
  static const String splashName = 'splash';
  static const String loginName = 'login';
  static const String homeName = 'home';
  static const String addTodoName = 'add-todo';
  static const String editTodoName = 'edit-todo';
  static const String statsName = 'stats';

  /// Get the router configuration
  static GoRouter getRouter() {
    return GoRouter(
      initialLocation: splash,
      routes: _buildRoutes(),
      redirect: _handleRedirect,
      refreshListenable: _AuthNotifier(),
    );
  }

  /// Build all application routes
  static List<RouteBase> _buildRoutes() {
    return [
      GoRoute(
        path: splash,
        name: splashName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        name: loginName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: home,
        name: homeName,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: addTodo,
        name: addTodoName,
        builder: (context, state) => const AddEditTodoScreen(),
      ),
      GoRoute(
        path: '$editTodo/:todoId',
        name: editTodoName,
        builder: (context, state) {
          final todoId = state.pathParameters['todoId']!;
          return AddEditTodoScreen(todoId: todoId);
        },
      ),
      GoRoute(
        path: stats,
        name: statsName,
        builder: (context, state) => const TodoStatsScreen(),
      ),
    ];
  }

  /// Handle route redirection based on authentication state
  static String? _handleRedirect(BuildContext context, GoRouterState state) {
    // Allow splash screen to always be accessible
    if (state.uri.path == splash) {
      return null;
    }

    // For now, let individual screens handle auth checks
    // The splash screen will handle the initial navigation
    return null;
  }

  /// Navigation helper methods
  static void goToSplash(BuildContext context) {
    context.go(splash);
  }

  static void goToLogin(BuildContext context) {
    context.go(login);
  }

  static void goToHome(BuildContext context) {
    context.go(home);
  }

  static void goToAddTodo(BuildContext context) {
    context.go(addTodo);
  }

  static void goToEditTodo(BuildContext context, String todoId) {
    context.go('$editTodo/$todoId');
  }

  static void goToStats(BuildContext context) {
    context.go(stats);
  }

  /// Push navigation helper methods
  static void pushToAddTodo(BuildContext context) {
    context.push(addTodo);
  }

  static void pushToEditTodo(BuildContext context, String todoId) {
    context.push('$editTodo/$todoId');
  }

  static void pushToStats(BuildContext context) {
    context.push(stats);
  }

  /// Check if current route matches a specific path
  static bool isCurrentRoute(BuildContext context, String path) {
    return GoRouterState.of(context).uri.path == path;
  }

  /// Get current route name
  static String? getCurrentRouteName(BuildContext context) {
    return GoRouterState.of(context).name;
  }

  /// Get current route path
  static String getCurrentRoutePath(BuildContext context) {
    return GoRouterState.of(context).uri.path;
  }
}

/// Provider for the router
final routerProvider = Provider<GoRouter>((ref) {
  return AppRouter.getRouter();
});

/// Auth notifier for router refresh
class _AuthNotifier extends ChangeNotifier {
  _AuthNotifier() {
    // This is a simple notifier for now
    // In a more complex app, you might want to listen to auth state changes
  }
}
