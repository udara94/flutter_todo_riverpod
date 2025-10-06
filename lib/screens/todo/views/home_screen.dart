import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../entity/todo.dart';
import '../controllers/todo_controller.dart';
import '../state/todo_state.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/enum/auth_state.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_dimensions.dart';
import '../../../generated/l10n.dart';
import '../../../utils/router/app_router.dart';
import '../../../widgets/common/app_text_input_field.dart';
import '../../../widgets/common/app_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();
  bool _isSearchExpanded = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final todoState = ref.watch(todoControllerProvider);

    // Redirect to login if not authenticated
    if (authState?.status != AuthStatus.authenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppRouter.goToLogin(context);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = authState!.user!;
    final filteredTodos = ref
        .watch(todoControllerProvider.notifier)
        .filteredTodos;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Welcome, ${user.name}'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Search toggle
          IconButton(
            onPressed: () {
              setState(() {
                _isSearchExpanded = !_isSearchExpanded;
                if (!_isSearchExpanded) {
                  _searchController.clear();
                  ref.read(todoControllerProvider.notifier).setSearchQuery('');
                }
              });
            },
            icon: Icon(_isSearchExpanded ? Icons.close : Icons.search),
          ),
          // Stats screen
          IconButton(
            onPressed: () {
              AppRouter.pushToStats(context);
            },
            icon: const Icon(Icons.analytics),
            tooltip: S.current.statsTitle,
          ),
          // Demo screen - commented out since demo screen doesn't exist
          // IconButton(
          //   onPressed: () {
          //     AppRouter.pushToDemo(context);
          //   },
          //   icon: const Icon(Icons.code),
          //   tooltip: 'Riverpod Demo',
          // ),
          // Logout button
          const LogoutButton(),
        ],
        bottom: _isSearchExpanded
            ? PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppSearchField(
                    controller: _searchController,
                    hintText: S.current.searchHint,
                    onChanged: (value) {
                      ref
                          .read(todoControllerProvider.notifier)
                          .setSearchQuery(value);
                    },
                    onClear: () {
                      _searchController.clear();
                      ref
                          .read(todoControllerProvider.notifier)
                          .setSearchQuery('');
                    },
                  ),
                ),
              )
            : null,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(todoControllerProvider.notifier).loadTodos(user.id);
        },
        child: Column(
          children: [
            // Stats Cards
            _buildStatsCards(todoState, user.id),

            // Filter Chips
            _buildFilterChips(),

            // Todo Count Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Todos: ${filteredTodos.length}',
                    style: const TextStyle(
                      fontSize: AppDimensions.fontSizeL,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  // Sort dropdown
                  DropdownButton<SortOrder>(
                    value: todoState.sortOrder,
                    items: SortOrder.values.map((order) {
                      return DropdownMenuItem(
                        value: order,
                        child: Text(_getSortOrderText(order)),
                      );
                    }).toList(),
                    onChanged: (order) {
                      if (order != null) {
                        ref
                            .read(todoControllerProvider.notifier)
                            .setSortOrder(order);
                      }
                    },
                  ),
                ],
              ),
            ),

            // Todo List
            Expanded(
              child: filteredTodos.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredTodos.length,
                      itemBuilder: (context, index) {
                        final todo = filteredTodos[index];
                        return _buildTodoCard(todo, user.id);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: AppFloatingActionButton(
        label: S.current.addTask,
        icon: Icons.add,
        onPressed: () {
          AppRouter.pushToAddTodo(context);
        },
        variant: AppButtonVariant.primary,
      ),
    );
  }

  Widget _buildStatsCards(TodoState todoState, String userId) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      child: todoState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildStatCard(
                  S.current.statTotal,
                  todoState.todos.length,
                  AppColors.info,
                ),
                _buildStatCard(
                  S.current.statCompleted,
                  todoState.todos
                      .where((t) => t.status == TodoStatus.completed)
                      .length,
                  AppColors.todoCompleted,
                ),
                _buildStatCard(
                  S.current.statPending,
                  todoState.todos
                      .where((t) => t.status == TodoStatus.pending)
                      .length,
                  AppColors.todoPending,
                ),
                _buildStatCard(
                  S.current.statInProgress,
                  todoState.todos
                      .where((t) => t.status == TodoStatus.inProgress)
                      .length,
                  AppColors.todoInProgress,
                ),
                _buildStatCard(
                  S.current.statOverdue,
                  todoState.todos
                      .where(
                        (t) =>
                            t.dueDate != null &&
                            t.dueDate!.isBefore(DateTime.now()) &&
                            t.status != TodoStatus.completed,
                      )
                      .length,
                  AppColors.todoOverdue,
                ),
              ],
            ),
    );
  }

  Widget _buildStatCard(String title, int count, Color color) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count.toString(),
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
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: AppDimensions.statCardHeight,
      padding: AppDimensions.paddingHorizontalL,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip(S.current.filterAll, null, null),
          _buildFilterChip(S.current.filterPending, TodoStatus.pending, null),
          _buildFilterChip(
            S.current.filterInProgress,
            TodoStatus.inProgress,
            null,
          ),
          _buildFilterChip(
            S.current.filterCompleted,
            TodoStatus.completed,
            null,
          ),
          _buildFilterChip(
            '${S.current.priorityHigh} ${S.current.todoPriority}',
            null,
            TodoPriority.high,
          ),
          _buildFilterChip(
            '${S.current.priorityMedium} ${S.current.todoPriority}',
            null,
            TodoPriority.medium,
          ),
          _buildFilterChip(
            '${S.current.priorityLow} ${S.current.todoPriority}',
            null,
            TodoPriority.low,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    TodoStatus? status,
    TodoPriority? priority,
  ) {
    final todoState = ref.watch(todoControllerProvider);
    final isSelected =
        todoState.selectedStatusFilter == status ||
        todoState.selectedPriorityFilter == priority;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (status != null) {
            ref
                .read(todoControllerProvider.notifier)
                .setStatusFilter(selected ? status : null);
          } else if (priority != null) {
            ref
                .read(todoControllerProvider.notifier)
                .setPriorityFilter(selected ? priority : null);
          } else {
            ref.read(todoControllerProvider.notifier).clearFilters();
          }
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Colors.blue[200],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTodoCard(Todo todo, String userId) {
    final isOverdue =
        todo.dueDate != null &&
        todo.dueDate!.isBefore(DateTime.now()) &&
        todo.status != TodoStatus.completed;

    return Card(
      margin: AppDimensions.marginBottomM,
      color: AppColors.surfaceLight,
      child: ListTile(
        leading: Checkbox(
          value: todo.status == TodoStatus.completed,
          onChanged: (value) {
            ref.read(todoControllerProvider.notifier).toggleTodoStatus(todo.id);
          },
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.status == TodoStatus.completed
                ? TextDecoration.lineThrough
                : null,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todo.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppDimensions.spacingXS),
            Row(
              children: [
                _buildPriorityChip(todo.priority),
                const SizedBox(width: AppDimensions.spacingS),
                _buildStatusChip(todo.status),
                if (isOverdue) ...[
                  const SizedBox(width: AppDimensions.spacingS),
                  _buildOverdueChip(),
                ],
              ],
            ),
            if (todo.tags != null && todo.tags!.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.spacingXS),
              Wrap(
                spacing: 4,
                children: todo.tags!
                    .split(',')
                    .map((tag) => tag.trim())
                    .where((tag) => tag.isNotEmpty)
                    .map(
                      (tag) => Chip(
                        label: Text(tag),
                        backgroundColor: AppColors.grey200,
                        labelStyle: const TextStyle(
                          fontSize: AppDimensions.fontSizeXS,
                          color: AppColors.textDark,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
            if (todo.dueDate != null) ...[
              const SizedBox(height: AppDimensions.spacingXS),
              Text(
                '${S.current.dueDateLabel} ${DateFormat('MMM dd, yyyy').format(todo.dueDate!)}',
                style: TextStyle(
                  fontSize: AppDimensions.fontSizeS,
                  color: isOverdue ? AppColors.todoOverdue : AppColors.grey600,
                  fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text(S.current.edit),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text(S.current.delete, style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              AppRouter.pushToEditTodo(context, todo.id);
            } else if (value == 'delete') {
              _showDeleteDialog(todo, userId);
            }
          },
        ),
        onTap: () {
          AppRouter.pushToEditTodo(context, todo.id);
        },
      ),
    );
  }

  Widget _buildPriorityChip(TodoPriority priority) {
    Color color;
    switch (priority) {
      case TodoPriority.high:
        color = AppColors.priorityHigh;
        break;
      case TodoPriority.medium:
        color = AppColors.priorityMedium;
        break;
      case TodoPriority.low:
        color = AppColors.priorityLow;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingS,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppDimensions.chipBorderRadius),
        border: Border.all(color: color),
      ),
      child: Text(
        priority.name.toUpperCase(),
        style: TextStyle(
          fontSize: AppDimensions.fontSizeXS,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildStatusChip(TodoStatus status) {
    Color color;
    switch (status) {
      case TodoStatus.pending:
        color = Colors.grey;
        break;
      case TodoStatus.inProgress:
        color = Colors.blue;
        break;
      case TodoStatus.completed:
        color = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingS,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppDimensions.chipBorderRadius),
        border: Border.all(color: color),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          fontSize: AppDimensions.fontSizeXS,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildOverdueChip() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingS,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppDimensions.chipBorderRadius),
        border: Border.all(color: Colors.red),
      ),
      child: const Text(
        'OVERDUE',
        style: TextStyle(
          fontSize: AppDimensions.fontSizeXS,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No todos found',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeXL,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first todo',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Todo todo, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.current.deleteTask),
        content: Text(S.current.deleteTaskConfirm),
        actions: [
          AppButton(
            text: S.current.cancel,
            onPressed: () => Navigator.of(context).pop(),
            variant: AppButtonVariant.text,
            size: AppButtonSize.medium,
          ),
          AppButton(
            text: S.current.delete,
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref
                    .read(todoControllerProvider.notifier)
                    .deleteTodo(todo.id, userId);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Todo deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting todo: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            variant: AppButtonVariant.danger,
            size: AppButtonSize.medium,
          ),
        ],
      ),
    );
  }

  String _getSortOrderText(SortOrder order) {
    switch (order) {
      case SortOrder.createdAtAsc:
        return 'Created (Oldest)';
      case SortOrder.createdAtDesc:
        return 'Created (Newest)';
      case SortOrder.titleAsc:
        return 'Title (A-Z)';
      case SortOrder.titleDesc:
        return 'Title (Z-A)';
      case SortOrder.priorityAsc:
        return 'Priority (Low-High)';
      case SortOrder.priorityDesc:
        return 'Priority (High-Low)';
    }
  }
}

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () async {
        try {
          await ref.read(authControllerProvider.notifier).logout();
          if (context.mounted) {
            AppRouter.goToLogin(context);
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${S.current.error} ${S.current.logout}: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      icon: const Icon(Icons.logout),
      tooltip: S.current.logout,
    );
  }
}
