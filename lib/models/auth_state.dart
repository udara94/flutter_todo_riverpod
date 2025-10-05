import 'user.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final DateTime? lastErrorTime;

  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
    this.lastErrorTime,
  });

  const AuthState.initial()
      : status = AuthStatus.initial,
        user = null,
        errorMessage = null,
        lastErrorTime = null;

  const AuthState.loading()
      : status = AuthStatus.loading,
        user = null,
        errorMessage = null,
        lastErrorTime = null;

  const AuthState.authenticated(this.user)
      : status = AuthStatus.authenticated,
        errorMessage = null,
        lastErrorTime = null;

  const AuthState.unauthenticated()
      : status = AuthStatus.unauthenticated,
        user = null,
        errorMessage = null,
        lastErrorTime = null;

  const AuthState.error(this.errorMessage, this.lastErrorTime)
      : status = AuthStatus.error,
        user = null;

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    DateTime? lastErrorTime,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      lastErrorTime: lastErrorTime ?? this.lastErrorTime,
    );
  }

  bool get isAuthenticated =>
      status == AuthStatus.authenticated && user != null;
  bool get isLoading => status == AuthStatus.loading;
  bool get hasError => status == AuthStatus.error;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthState &&
        other.status == status &&
        other.user == user &&
        other.errorMessage == errorMessage &&
        other.lastErrorTime == lastErrorTime;
  }

  @override
  int get hashCode {
    return status.hashCode ^
    user.hashCode ^
    errorMessage.hashCode ^
    lastErrorTime.hashCode;
  }

  @override
  String toString() {
    return 'AuthState(status: $status, user: $user, errorMessage: $errorMessage, lastErrorTime: $lastErrorTime)';
  }
}
