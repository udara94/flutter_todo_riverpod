import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../entity/user.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static SharedPreferences? _prefs;
  static final _uuid = const Uuid();

  static void initialize(SharedPreferences prefs) {
    _prefs = prefs;
  }

  // Mock authentication - simulates API calls
  static Future<User> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock validation
    if (email.isEmpty || password.isEmpty) {
      throw AuthException('Email and password are required');
    }

    if (password.length < 6) {
      throw AuthException('Password must be at least 6 characters');
    }

    // Simulate random failures for error handling demo
    if (Random().nextDouble() < 0.1) {
      throw AuthException('Network error. Please try again.');
    }

    // Create mock user
    final user = User(
      id: _uuid.v4(),
      email: email,
      name: email
          .split('@')[0]
          .replaceAll('.', ' ')
          .split(' ')
          .map(
            (word) => word.isNotEmpty
                ? word[0].toUpperCase() + word.substring(1)
                : '',
          )
          .join(' '),
      avatarUrl:
          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(email)}&background=random',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastLoginAt: DateTime.now(),
    );

    // Save to local storage
    await _saveUser(user);
    await _saveToken('mock_token_${_uuid.v4()}');

    return user;
  }

  static Future<void> logout() async {
    await _prefs!.remove(_tokenKey);
    await _prefs!.remove(_userKey);
  }

  static Future<User?> getCurrentUser() async {
    final token = _prefs!.getString(_tokenKey);
    if (token == null) return null;

    final userJson = _prefs!.getString(_userKey);
    if (userJson == null) return null;

    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return User.fromJson(userMap);
    } catch (e) {
      await logout(); // Clear invalid data
      return null;
    }
  }

  static Future<bool> isAuthenticated() async {
    final token = _prefs!.getString(_tokenKey);
    return token != null;
  }

  static Future<void> refreshUser() async {
    final currentUser = await getCurrentUser();
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(lastLoginAt: DateTime.now());
      await _saveUser(updatedUser);
    }
  }

  static Future<void> _saveUser(User user) async {
    await _prefs!.setString(_userKey, jsonEncode(user.toJson()));
  }

  static Future<void> _saveToken(String token) async {
    await _prefs!.setString(_tokenKey, token);
  }
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}
