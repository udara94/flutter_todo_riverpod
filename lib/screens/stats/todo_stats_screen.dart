import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../models/todo.dart';

class TodoStatsScreen extends ConsumerWidget {
  const TodoStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final darkMode = ref.watch(darkModeProvider);

    if (!authState.isAuthenticated) {
      return const Scaffold(
        body: Center(child: Text('Please login to view stats')),
      );
    }

    final userId = authState.user!.id;
    final todoStats = ref.watch(todoStatsProvider(userId));
    final todos = ref.watch(todoListProvider(userId));

    return Theme(
      data: Theme.of(
        context,
      ).copyWith(brightness: darkMode ? Brightness.dark : Brightness.light),
      child: Scaffold(
        backgroundColor: darkMode ? Colors.grey[900] : Colors.grey[50],
        appBar: AppBar(
          title: const Text('Todo Statistics'),
          backgroundColor: darkMode ? Colors.grey[800] : Colors.blue[600],
          foregroundColor: Colors.white,
        ),
        body: todoStats.when(
          data: (stats) => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overview Cards
                _buildOverviewCards(stats, darkMode),

                const SizedBox(height: 24),

                // Priority Distribution
                _buildPriorityChart(todos, darkMode),

                const SizedBox(height: 24),

                // Status Distribution
                _buildStatusChart(todos, darkMode),

                const SizedBox(height: 24),

                // Recent Activity
                _buildRecentActivity(todos, darkMode),

                const SizedBox(height: 24),

                // Performance Metrics
                _buildPerformanceMetrics(todos, darkMode),
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                const SizedBox(height: 16),
                Text(
                  'Error loading statistics',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(todoStatsProvider(userId));
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewCards(TodoStats stats, bool darkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: darkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
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
              darkMode,
            ),
            _buildStatCard(
              'Completed',
              stats.completed.toString(),
              Icons.check_circle,
              Colors.green,
              darkMode,
            ),
            _buildStatCard(
              'In Progress',
              stats.inProgress.toString(),
              Icons.play_circle,
              Colors.orange,
              darkMode,
            ),
            _buildStatCard(
              'Overdue',
              stats.overdue.toString(),
              Icons.warning,
              Colors.red,
              darkMode,
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
      bool darkMode,
      ) {
    return Card(
      color: darkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: darkMode ? Colors.grey[300] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityChart(List<Todo> todos, bool darkMode) {
    final priorityCounts = <TodoPriority, int>{};
    for (final priority in TodoPriority.values) {
      priorityCounts[priority] = todos
          .where((t) => t.priority == priority)
          .length;
    }

    return Card(
      color: darkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Priority Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
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
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: darkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          '${entry.value} (${percentage.toStringAsFixed(1)}%)',
                          style: TextStyle(
                            color: darkMode
                                ? Colors.grey[300]
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: darkMode
                          ? Colors.grey[700]
                          : Colors.grey[200],
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

  Widget _buildStatusChart(List<Todo> todos, bool darkMode) {
    final statusCounts = <TodoStatus, int>{};
    for (final status in TodoStatus.values) {
      statusCounts[status] = todos.where((t) => t.status == status).length;
    }

    return Card(
      color: darkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
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
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: darkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          '${entry.value} (${percentage.toStringAsFixed(1)}%)',
                          style: TextStyle(
                            color: darkMode
                                ? Colors.grey[300]
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: darkMode
                          ? Colors.grey[700]
                          : Colors.grey[200],
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

  Widget _buildRecentActivity(List<Todo> todos, bool darkMode) {
    final recentTodos = todos.take(5).toList();

    return Card(
      color: darkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            if (recentTodos.isEmpty)
              Text(
                'No recent activity',
                style: TextStyle(
                  color: darkMode ? Colors.grey[400] : Colors.grey[600],
                ),
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
                          style: TextStyle(
                            color: darkMode ? Colors.white : Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatDate(todo.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: darkMode
                              ? Colors.grey[400]
                              : Colors.grey[600],
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

  Widget _buildPerformanceMetrics(List<Todo> todos, bool darkMode) {
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
      color: darkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Metrics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'Completion Rate',
                    '${completionRate.toStringAsFixed(1)}%',
                    Icons.trending_up,
                    completionRate > 70 ? Colors.green : Colors.orange,
                    darkMode,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricItem(
                    'Overdue Rate',
                    '${overdueRate.toStringAsFixed(1)}%',
                    Icons.trending_down,
                    overdueRate < 20 ? Colors.green : Colors.red,
                    darkMode,
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
      bool darkMode,
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: darkMode ? Colors.grey[300] : Colors.grey[600],
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
