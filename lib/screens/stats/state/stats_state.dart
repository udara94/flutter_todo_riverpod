import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../entity/todo.dart';

part 'stats_state.freezed.dart';

@Freezed(toJson: false, fromJson: false)
abstract class StatsState with _$StatsState {
  factory StatsState({
    @Default(false) bool isLoading,
    String? errorMessage,
    DateTime? lastErrorTime,
    TodoStats? stats,
  }) = _StatsState;

  StatsState._();
}

class TodoStats {
  final int total;
  final int completed;
  final int pending;
  final int inProgress;
  final int overdue;

  const TodoStats({
    required this.total,
    required this.completed,
    required this.pending,
    required this.inProgress,
    required this.overdue,
  });

  factory TodoStats.fromTodos(List<Todo> todos) {
    final now = DateTime.now();
    return TodoStats(
      total: todos.length,
      completed: todos.where((t) => t.status == TodoStatus.completed).length,
      pending: todos.where((t) => t.status == TodoStatus.pending).length,
      inProgress: todos.where((t) => t.status == TodoStatus.inProgress).length,
      overdue: todos
          .where(
            (t) =>
                t.dueDate != null &&
                t.dueDate!.isBefore(now) &&
                t.status != TodoStatus.completed,
          )
          .length,
    );
  }
}
