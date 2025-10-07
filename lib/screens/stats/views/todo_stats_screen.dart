import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../entity/todo.dart';
import '../../auth/enum/auth_state.dart';
import '../controllers/stats_controller.dart';
import '../state/stats_state.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../todo/controllers/todo_controller.dart';
import '../../../utils/constants/app_dimensions.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../generated/l10n.dart';

class TodoStatsScreen extends ConsumerWidget {
  const TodoStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final statsState = ref.watch(statsControllerProvider);
    final todoState = ref.watch(todoControllerProvider);

    if (authState?.status != AuthStatus.authenticated) {
      return Scaffold(
        body: Center(child: Text(S.current.pleaseLoginToViewStats)),
      );
    }

    final userId = authState!.user!.id;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.primaryGradient,
            ),
          ),
          child: AppBar(
            title: Text(S.current.statsTitle),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
      ),
      body: statsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : statsState.errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: AppDimensions.iconXXL,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: AppDimensions.spacingL),
                  Text(
                    S.current.errorLoadingStatistics,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppDimensions.spacingL),
                  Text(
                    statsState.errorMessage!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.spacingL),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(statsControllerProvider.notifier)
                          .loadStats(userId);
                    },
                    child: Text(S.current.retry),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: AppDimensions.paddingAllL,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overview Cards
                  _buildOverviewCards(
                    statsState.stats ?? TodoStats.fromTodos(todoState.todos),
                  ),

                  const SizedBox(height: AppDimensions.spacingXXL),

                  // Priority Distribution
                  _buildPriorityChart(todoState.todos),

                  const SizedBox(height: AppDimensions.spacingXXL),

                  // Status Distribution
                  _buildStatusChart(todoState.todos),

                  const SizedBox(height: AppDimensions.spacingXXL),

                  // Recent Activity
                  _buildRecentActivity(todoState.todos),

                  const SizedBox(height: AppDimensions.spacingXXL),

                  // Performance Metrics
                  _buildPerformanceMetrics(todoState.todos),
                ],
              ),
            ),
    );
  }

  Widget _buildOverviewCards(TodoStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.overview,
          style: const TextStyle(
            fontSize: AppDimensions.fontSizeXXL,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: AppDimensions.spacingL,
          mainAxisSpacing: AppDimensions.spacingL,
          childAspectRatio: 1,
          children: [
            _buildStatCard(
              S.current.totalTodos,
              stats.total.toString(),
              Icons.list_alt,
              AppColors.info,
            ),
            _buildStatCard(
              S.current.statCompleted,
              stats.completed.toString(),
              Icons.check_circle,
              AppColors.todoCompleted,
            ),
            _buildStatCard(
              S.current.statInProgress,
              stats.inProgress.toString(),
              Icons.play_circle,
              AppColors.todoInProgress,
            ),
            _buildStatCard(
              S.current.statOverdue,
              stats.overdue.toString(),
              Icons.warning,
              AppColors.todoOverdue,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      color: AppColors.surfaceLight,
      child: Padding(
        padding: AppDimensions.paddingAllXL,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: AppDimensions.iconXL),
            SizedBox(height: AppDimensions.spacingM),
            Text(
              value,
              style: TextStyle(
                fontSize: AppDimensions.fontSizeXXXL,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimensions.spacingS),
            Text(
              title,
              style: const TextStyle(
                fontSize: AppDimensions.fontSizeM,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityChart(List<Todo> todos) {
    final priorityCounts = <TodoPriority, int>{};
    for (final priority in TodoPriority.values) {
      priorityCounts[priority] = todos
          .where((t) => t.priority == priority)
          .length;
    }

    return Card(
      color: AppColors.surfaceLight,
      child: Padding(
        padding: AppDimensions.paddingAllL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.current.priorityDistribution,
              style: const TextStyle(
                fontSize: AppDimensions.fontSizeL,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppDimensions.spacingL),
            ...priorityCounts.entries.map((entry) {
              final percentage = todos.isEmpty
                  ? 0.0
                  : (entry.value / todos.length) * 100;
              return Padding(
                padding: EdgeInsets.only(bottom: AppDimensions.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key.name.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${entry.value} (${percentage.toStringAsFixed(1)}%)',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.spacingXS),
                    LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: AppColors.grey200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getPriorityColor(entry.key),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChart(List<Todo> todos) {
    final statusCounts = <TodoStatus, int>{};
    for (final status in TodoStatus.values) {
      statusCounts[status] = todos.where((t) => t.status == status).length;
    }

    return Card(
      color: AppColors.surfaceLight,
      child: Padding(
        padding: AppDimensions.paddingAllL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.current.statusDistribution,
              style: const TextStyle(
                fontSize: AppDimensions.fontSizeL,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingL),
            ...statusCounts.entries.map((entry) {
              final percentage = todos.isEmpty
                  ? 0.0
                  : (entry.value / todos.length) * 100;
              return Padding(
                padding: EdgeInsets.only(bottom: AppDimensions.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key.name.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${entry.value} (${percentage.toStringAsFixed(1)}%)',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.spacingXS),
                    LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: AppColors.grey200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getStatusColor(entry.key),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(List<Todo> todos) {
    final recentTodos = todos.take(5).toList();

    return Card(
      color: AppColors.surfaceLight,
      child: Padding(
        padding: AppDimensions.paddingAllL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.current.recentActivity,
              style: const TextStyle(
                fontSize: AppDimensions.fontSizeL,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingL),
            if (recentTodos.isEmpty)
              Text(
                S.current.noRecentActivity,
                style: const TextStyle(color: Colors.grey),
              )
            else
              ...recentTodos
                  .map(
                    (todo) => Padding(
                      padding: EdgeInsets.only(bottom: AppDimensions.spacingS),
                      child: Row(
                        children: [
                          Icon(
                            _getStatusIcon(todo.status),
                            color: _getStatusColor(todo.status),
                            size: AppDimensions.iconS,
                          ),
                          SizedBox(width: AppDimensions.spacingS),
                          Expanded(
                            child: Text(
                              todo.title,
                              style: const TextStyle(color: Colors.black87),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            _formatDate(todo.createdAt),
                            style: const TextStyle(
                              fontSize: AppDimensions.fontSizeS,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceMetrics(List<Todo> todos) {
    final completedTodos = todos
        .where((t) => t.status == TodoStatus.completed)
        .length;
    final completionRate = todos.isEmpty
        ? 0.0
        : (completedTodos / todos.length) * 100;

    final overdueTodos = todos
        .where(
          (t) =>
              t.dueDate != null &&
              t.dueDate!.isBefore(DateTime.now()) &&
              t.status != TodoStatus.completed,
        )
        .length;

    final overdueRate = todos.isEmpty
        ? 0.0
        : (overdueTodos / todos.length) * 100;

    return Card(
      color: AppColors.surfaceLight,
      child: Padding(
        padding: AppDimensions.paddingAllL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.current.performanceMetrics,
              style: const TextStyle(
                fontSize: AppDimensions.fontSizeL,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingL),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    S.current.completionRate,
                    '${completionRate.toStringAsFixed(1)}%',
                    Icons.trending_up,
                    completionRate > 70 ? AppColors.success : AppColors.warning,
                  ),
                ),
                SizedBox(width: AppDimensions.spacingL),
                Expanded(
                  child: _buildMetricItem(
                    S.current.overdueRate,
                    '${overdueRate.toStringAsFixed(1)}%',
                    Icons.trending_down,
                    overdueRate < 20 ? AppColors.success : AppColors.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: AppDimensions.paddingAllL,
      decoration: BoxDecoration(
        color: AppColors.withOpacity(color, 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(color: AppColors.withOpacity(color, 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: AppDimensions.iconL),
          SizedBox(height: AppDimensions.spacingS),
          Text(
            value,
            style: TextStyle(
              fontSize: AppDimensions.fontSizeXL,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: AppDimensions.fontSizeS,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.high:
        return AppColors.priorityHigh;
      case TodoPriority.medium:
        return AppColors.priorityMedium;
      case TodoPriority.low:
        return AppColors.priorityLow;
    }
  }

  Color _getStatusColor(TodoStatus status) {
    switch (status) {
      case TodoStatus.pending:
        return AppColors.todoPending;
      case TodoStatus.inProgress:
        return AppColors.todoInProgress;
      case TodoStatus.completed:
        return AppColors.todoCompleted;
    }
  }

  IconData _getStatusIcon(TodoStatus status) {
    switch (status) {
      case TodoStatus.pending:
        return Icons.schedule;
      case TodoStatus.inProgress:
        return Icons.play_circle;
      case TodoStatus.completed:
        return Icons.check_circle;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${S.current.days} ${S.current.ago}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${S.current.hours} ${S.current.ago}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${S.current.minutes} ${S.current.ago}';
    } else {
      return S.current.justNow;
    }
  }
}
