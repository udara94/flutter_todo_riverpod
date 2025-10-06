import 'dart:ui';
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

    return GestureDetector(
      onTap: () => _showTodoOptionsBottomSheet(todo, userId),
      child: Container(
        margin: AppDimensions.marginBottomM,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.surfaceLight.withAlpha(1),
              AppColors.surfaceLight.withAlpha(30),
            ],
            stops: const [0.0, 1.0],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.15), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                80,
                16,
              ), // Extra right padding for priority chip
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row with checkbox and title
                  Row(
                    children: [
                      // Left side visual element for balance
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: _getPriorityColor(
                            todo.priority,
                          ).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Checkbox(
                        value: todo.status == TodoStatus.completed,
                        onChanged: (value) {
                          ref
                              .read(todoControllerProvider.notifier)
                              .toggleTodoStatus(todo.id);
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          todo.title,
                          style: TextStyle(
                            decoration: todo.status == TodoStatus.completed
                                ? TextDecoration.lineThrough
                                : null,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Description
                  Text(
                    todo.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Bottom row with status and due date
                  Row(
                    children: [
                      // Status with label
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          _buildStatusChip(todo.status),
                        ],
                      ),
                      if (todo.dueDate != null) ...[
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Due Date',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isOverdue
                                      ? AppColors.todoOverdue.withOpacity(0.1)
                                      : AppColors.grey200,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isOverdue
                                        ? AppColors.todoOverdue
                                        : AppColors.grey300,
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  DateFormat(
                                    'MMM dd, yyyy',
                                  ).format(todo.dueDate!),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isOverdue
                                        ? AppColors.todoOverdue
                                        : AppColors.grey600,
                                    fontWeight: isOverdue
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Priority chip in top right corner
            Positioned(
              top: 0,
              right: 0,
              child: _buildPriorityChipCorner(todo.priority),
            ),
          ],
        ),
      ),
    );
  }

  void _showTodoOptionsBottomSheet(Todo todo, String userId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Todo title
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Text(
                    todo.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 20),
                // Action buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Edit button
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          text: S.current.edit,
                          onPressed: () {
                            Navigator.of(context).pop();
                            AppRouter.pushToEditTodo(context, todo.id);
                          },
                          variant: AppButtonVariant.primary,
                          size: AppButtonSize.large,
                          icon: Icons.edit,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Delete button
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          text: S.current.delete,
                          onPressed: () {
                            Navigator.of(context).pop();
                            _showDeleteDialog(todo, userId);
                          },
                          variant: AppButtonVariant.danger,
                          size: AppButtonSize.large,
                          icon: Icons.delete,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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

  Widget _buildPriorityChipCorner(TodoPriority priority) {
    Color color;
    IconData icon;
    switch (priority) {
      case TodoPriority.high:
        color = AppColors.priorityHigh;
        icon = Icons.keyboard_arrow_up;
        break;
      case TodoPriority.medium:
        color = AppColors.priorityMedium;
        icon = Icons.remove;
        break;
      case TodoPriority.low:
        color = AppColors.priorityLow;
        icon = Icons.keyboard_arrow_down;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(12), // Match card's top right corner
          bottomRight: Radius.circular(0), // Match card's bottom right corner
          topLeft: Radius.circular(0), // Sharp corner
          bottomLeft: Radius.circular(12), // Sharp corner
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            priority.name.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(TodoStatus status) {
    Color color;
    IconData icon;
    switch (status) {
      case TodoStatus.pending:
        color = Colors.grey;
        icon = Icons.schedule;
        break;
      case TodoStatus.inProgress:
        color = Colors.blue;
        icon = Icons.play_circle_outline;
        break;
      case TodoStatus.completed:
        color = Colors.green;
        icon = Icons.check_circle_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            status.name.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
        ],
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
