import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

enum TodoPriority { low, medium, high }

enum TodoStatus { pending, inProgress, completed }

@JsonSerializable()
class Todo {
  final String id;
  final String title;
  final String description;
  final TodoPriority priority;
  final TodoStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? dueDate;
  final List<String> tags;
  final String userId;

  const Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.dueDate,
    required this.tags,
    required this.userId,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
  Map<String, dynamic> toJson() => _$TodoToJson(this);

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    TodoPriority? priority,
    TodoStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueDate,
    List<String>? tags,
    String? userId,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueDate: dueDate ?? this.dueDate,
      tags: tags ?? this.tags,
      userId: userId ?? this.userId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Todo &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.priority == priority &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.dueDate == dueDate &&
        other.tags.toString() == tags.toString() &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    title.hashCode ^
    description.hashCode ^
    priority.hashCode ^
    status.hashCode ^
    createdAt.hashCode ^
    updatedAt.hashCode ^
    dueDate.hashCode ^
    tags.hashCode ^
    userId.hashCode;
  }

  @override
  String toString() {
    return 'Todo(id: $id, title: $title, description: $description, priority: $priority, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, dueDate: $dueDate, tags: $tags, userId: $userId)';
  }
}
