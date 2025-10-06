import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../entity/todo.dart';
import '../../auth/enum/auth_state.dart';
import '../controllers/stats_controller.dart';
import '../state/stats_state.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../todo/controllers/todo_controller.dart';
import '../../../utils/constants/app_dimensions.dart';
import '../../../generated/l10n.dart';

class TodoStatsScreen extends ConsumerWidget {
  const TodoStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final statsState = ref.watch(statsControllerProvider);
    final todoState = ref.watch(todoControllerProvider);

    if (authState?.status != AuthStatus.authenticated) {
      return const Scaffold(
        body: Center(child: Text('Please login to view stats')),
      );
    }

    final userId = authState!.user!.id;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(S.current.statsTitle),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
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
                    color: Colors.red[400],
                  ),
                  const SizedBox(height: AppDimensions.spacingL),
                  Text(
                    'Error loading statistics',
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
                    child: const Text('Retry'),
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
        const Text(
          'Overview',
          style: TextStyle(
            fontSize: AppDimensions.fontSizeXXL,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildStatCard(
              'Total Todos',
              stats.total.toString(),
              Icons.list_alt,
              Colors.blue,
            ),
            _buildStatCard(
              S.current.statCompleted,
              stats.completed.toString(),
              Icons.check_circle,
              Colors.green,
            ),
            _buildStatCard(
              S.current.statInProgress,
              stats.inProgress.toString(),
              Icons.play_circle,
              Colors.orange,
            ),
            _buildStatCard(
              S.current.statOverdue,
              stats.overdue.toString(),
              Icons.warning,
              Colors.red,
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
      color: Colors.white,
      child: Padding(
        padding: AppDimensions.paddingAllL,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: AppDimensions.fontSizeXXXL,
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
      color: Colors.white,
      child: Padding(
        padding: AppDimensions.paddingAllL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Priority Distribution',
              style: TextStyle(
                fontSize: AppDimensions.fontSizeXL,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingL),
            ...priorityCounts.entries.map((entry) {
              final percentage = todos.isEmpty
                  ? 0.0
                  : (entry.value / todos.length) * 100;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
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
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '${entry.value} (${percentage.toStringAsFixed(1)}%)',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.grey[200],
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
      color: Colors.white,
      child: Padding(
        padding: AppDimensions.paddingAllL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Status Distribution',
              style: TextStyle(
                fontSize: AppDimensions.fontSizeXL,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingL),
            ...statusCounts.entries.map((entry) {
              final percentage = todos.isEmpty
                  ? 0.0
                  : (entry.value / todos.length) * 100;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
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
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '${entry.value} (${percentage.toStringAsFixed(1)}%)',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.grey[200],
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
      color: Colors.white,
      child: Padding(
        padding: AppDimensions.paddingAllL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: AppDimensions.fontSizeXL,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingL),
            if (recentTodos.isEmpty)
              const Text(
                'No recent activity',
                style: TextStyle(color: Colors.grey),
              )
            else
              ...recentTodos
                  .map(
                    (todo) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            _getStatusIcon(todo.status),
                            color: _getStatusColor(todo.status),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
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
                              color: Colors.grey,
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
      color: Colors.white,
      child: Padding(
        padding: AppDimensions.paddingAllL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance Metrics',
              style: TextStyle(
                fontSize: AppDimensions.fontSizeXL,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingL),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'Completion Rate',
                    '${completionRate.toStringAsFixed(1)}%',
                    Icons.trending_up,
                    completionRate > 70 ? Colors.green : Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricItem(
                    'Overdue Rate',
                    '${overdueRate.toStringAsFixed(1)}%',
                    Icons.trending_down,
                    overdueRate < 20 ? Colors.green : Colors.red,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
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
        return Colors.red;
      case TodoPriority.medium:
        return Colors.orange;
      case TodoPriority.low:
        return Colors.green;
    }
  }

  Color _getStatusColor(TodoStatus status) {
    switch (status) {
      case TodoStatus.pending:
        return Colors.grey;
      case TodoStatus.inProgress:
        return Colors.blue;
      case TodoStatus.completed:
        return Colors.green;
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
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
