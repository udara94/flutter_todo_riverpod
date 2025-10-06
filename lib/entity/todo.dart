import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

enum TodoPriority { low, medium, high }

enum TodoStatus { pending, inProgress, completed }

@freezed
abstract class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String title,
    required String description,
    required TodoPriority priority,
    required TodoStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? dueDate,
    required String? tags,
    required String userId,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
