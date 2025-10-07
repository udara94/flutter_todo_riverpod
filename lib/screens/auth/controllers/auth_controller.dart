import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_app/entity/user.dart';
import 'package:todo_app/screens/auth/enum/auth_state.dart';
import 'package:todo_app/services/auth_service.dart';

import '../state/auth_state.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  AuthState? build() {
    _checkExistingAuth();
    return AuthState(status: AuthStatus.initial);
  }

  Future<void> _checkExistingAuth() async {
    try {
      final isAuthenticated = await AuthService.isAuthenticated();
      if (isAuthenticated) {
        final user = await AuthService.getCurrentUser();
        if (user != null) {
          state = AuthState(status: AuthStatus.authenticated, user: user);
        } else {
          state = AuthState(status: AuthStatus.unauthenticated);
        }
      } else {
        state = AuthState(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<User> login(String email, String password) async {
    state = state?.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final response = await AuthService.login(email, password);
      state = state?.copyWith(status: AuthStatus.authenticated, user: response);
      return response;
    } catch (e) {
      state = state?.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
        lastErrorTime: DateTime.now(),
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    state = state?.copyWith(status: AuthStatus.unauthenticated, user: null);
  }

  void clearError() {
    state = state?.copyWith(errorMessage: null, lastErrorTime: null);
  }
}
