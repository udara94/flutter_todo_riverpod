import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.g.dart';
part 'user.freezed.dart';

@freezed
abstract class User with _$User{

  const factory User({
    required String id,
    required String email,
    required String name,
    String? avatarUrl,
    required DateTime createdAt,
    required DateTime lastLoginAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

}
