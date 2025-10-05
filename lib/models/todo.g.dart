// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) => Todo(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  priority: $enumDecode(_$TodoPriorityEnumMap, json['priority']),
  status: $enumDecode(_$TodoStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
  userId: json['userId'] as String,
);

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'priority': _$TodoPriorityEnumMap[instance.priority]!,
  'status': _$TodoStatusEnumMap[instance.status]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'dueDate': instance.dueDate?.toIso8601String(),
  'tags': instance.tags,
  'userId': instance.userId,
};

const _$TodoPriorityEnumMap = {
  TodoPriority.low: 'low',
  TodoPriority.medium: 'medium',
  TodoPriority.high: 'high',
};

const _$TodoStatusEnumMap = {
  TodoStatus.pending: 'pending',
  TodoStatus.inProgress: 'inProgress',
  TodoStatus.completed: 'completed',
};
