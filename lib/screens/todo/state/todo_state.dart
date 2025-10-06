import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../entity/todo.dart';

part 'todo_state.freezed.dart';

@Freezed(toJson: false, fromJson: false)
abstract class TodoState with _$TodoState {
  factory TodoState({
    @Default([]) List<Todo> todos,
    @Default(false) bool isLoading,
    String? errorMessage,
    DateTime? lastErrorTime,
    @Default('') String searchQuery,
    TodoStatus? selectedStatusFilter,
    TodoPriority? selectedPriorityFilter,
    @Default(SortOrder.createdAtDesc) SortOrder sortOrder,
  }) = _TodoState;

  TodoState._();
}

enum SortOrder {
  createdAtAsc,
  createdAtDesc,
  titleAsc,
  titleDesc,
  priorityAsc,
  priorityDesc,
}
