import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_app/services/todo_service.dart';
import '../state/stats_state.dart';

part 'stats_controller.g.dart';

@riverpod
class StatsController extends _$StatsController {
  @override
  StatsState build() {
    return StatsState();
  }

  Future<void> loadStats(String userId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final todos = await TodoService.getTodos(userId);
      final stats = TodoStats.fromTodos(todos);

      state = state.copyWith(stats: stats, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        lastErrorTime: DateTime.now(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null, lastErrorTime: null);
  }
}
