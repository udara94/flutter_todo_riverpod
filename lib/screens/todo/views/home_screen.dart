import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../entity/todo.dart';
import '../controllers/todo_controller.dart';
import '../state/todo_state.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/enum/auth_state.dart';
import '../../theme/controllers/theme_controller.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_dimensions.dart';
import '../../../generated/l10n.dart';
import '../../../utils/router/app_router.dart';
import '../../../utils/snackbar_util.dart';
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
    final themeState = ref.watch(themeControllerProvider);

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
            title: Text(S.current.homeTitle),
            backgroundColor: Colors.transparent,
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
                      ref
                          .read(todoControllerProvider.notifier)
                          .setSearchQuery('');
                    }
                  });
                },
                icon: Icon(_isSearchExpanded ? Icons.close : Icons.search),
              ),
              // More options menu
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'stats':
                      AppRouter.pushToStats(context);
                      break;
                    case 'theme':
                      // Theme toggle is handled by the Switch widget itself
                      break;
                    case 'test_todos':
                      _addTestTodos();
                      break;
                    case 'logout':
                      _showLogoutDialog();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'stats',
                    child: Row(
                      children: [
                        const Icon(Icons.analytics),
                        const SizedBox(width: AppDimensions.spacingS),
                        Text(S.current.statsTitle),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'theme',
                    child: Row(
                      children: [
                        Icon(
                          themeState.isDarkMode
                              ? Icons.dark_mode
                              : Icons.light_mode,
                        ),
                        const SizedBox(width: AppDimensions.spacingS),
                        Text(
                          themeState.isDarkMode
                              ? S.current.darkMode
                              : S.current.lightMode,
                        ),
                        const Spacer(),
                        Switch(
                          value: themeState.isDarkMode,
                          onChanged: (value) {
                            ref
                                .read(themeControllerProvider.notifier)
                                .setDarkMode(value);
                          },
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'test_todos',
                    child: Row(
                      children: [
                        const Icon(Icons.add_task),
                        const SizedBox(width: AppDimensions.spacingS),
                        Text('Add Test Todos'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        const Icon(Icons.logout),
                        const SizedBox(width: AppDimensions.spacingS),
                        Text(S.current.logout),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(todoControllerProvider.notifier).loadTodos(user.id);
        },
        child: Column(
          children: [
            // Search Field (when expanded)
            if (_isSearchExpanded)
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
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

            // Filter Chips
            // _buildFilterChips(),
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
                  SnackBarUtil.showSuccess(
                    context,
                    'Todo deleted successfully',
                  );
                }
              } catch (e) {
                if (mounted) {
                  SnackBarUtil.showError(context, 'Error deleting todo: $e');
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
        return S.current.sortCreatedOldest;
      case SortOrder.createdAtDesc:
        return S.current.sortCreatedNewest;
      case SortOrder.titleAsc:
        return S.current.sortTitleAZ;
      case SortOrder.titleDesc:
        return S.current.sortTitleZA;
      case SortOrder.priorityAsc:
        return S.current.sortPriorityLowHigh;
      case SortOrder.priorityDesc:
        return S.current.sortPriorityHighLow;
    }
  }

  Future<void> _addTestTodos() async {
    final authState = ref.read(authControllerProvider);
    if (authState?.user == null) return;

    final userId = authState!.user!.id;
    final todoController = ref.read(todoControllerProvider.notifier);

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Call controller method to add test todos
      final result = await todoController.addTestTodos(userId);

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();

        // Show result message
        if (result.error != null) {
          // Show error message
          SnackBarUtil.showError(
            context,
            'Error adding test todos: ${result.error}',
          );
        } else {
          // Show success message
          final message =
              'Added ${result.successCount} out of ${result.totalCount} test todos successfully!';
          if (result.successCount == result.totalCount) {
            SnackBarUtil.showSuccess(context, message);
          } else {
            SnackBarUtil.showWarning(context, message);
          }
        }
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();

        // Show error message
        SnackBarUtil.showError(context, 'Error adding test todos: $e');
      }
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.current.logout),
        content: Text(S.current.logoutConfirm),
        actions: [
          AppButton(
            text: S.current.cancel,
            onPressed: () => Navigator.of(context).pop(),
            variant: AppButtonVariant.text,
            size: AppButtonSize.medium,
          ),
          AppButton(
            text: S.current.logout,
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(authControllerProvider.notifier).logout();
                if (context.mounted) {
                  AppRouter.goToLogin(context);
                  SnackBarUtil.showSuccess(
                    context,
                    '${S.current.logout} ${S.current.success}',
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  SnackBarUtil.showError(
                    context,
                    '${S.current.error} ${S.current.logout}: $e',
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
            SnackBarUtil.showError(
              context,
              '${S.current.error} ${S.current.logout}: $e',
            );
          }
        }
      },
      icon: const Icon(Icons.logout),
      tooltip: S.current.logout,
    );
  }
}
