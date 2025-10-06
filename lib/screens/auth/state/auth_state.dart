import 'package:todo_app/screens/auth/enum/auth_state.dart';

import '../../../entity/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@Freezed(toJson: false, fromJson: false)
abstract class AuthState with _$AuthState {
  factory AuthState({
    required AuthStatus status,
    User? user,
    String? errorMessage,
    DateTime? lastErrorTime,
  }) = _AuthState;

  AuthState._();

  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get hasError => errorMessage != null;
}
