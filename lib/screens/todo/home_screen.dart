import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/providers.dart';
import '../../models/todo.dart';
import '../login_screen.dart';

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
    final authState = ref.watch(authStateProvider);
    final darkMode = ref.watch(darkModeProvider);

    // Redirect to login if not authenticated
    if (!authState.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/login');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = authState.user!;
    final todos = ref.watch(filteredTodosProvider(user.id));
    final todoStats = ref.watch(todoStatsProvider(user.id));
    final todoCount = ref.watch(todoCountProvider(user.id));

    return Theme(
      data: Theme.of(
        context,
      ).copyWith(brightness: darkMode ? Brightness.dark : Brightness.light),
      child: Scaffold(
        backgroundColor: darkMode ? Colors.grey[900] : Colors.grey[50],
        appBar: AppBar(
          title: Text('Welcome, ${user.name}'),
          backgroundColor: darkMode ? Colors.grey[800] : Colors.blue[600],
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
                    ref.read(searchQueryProvider.notifier).state = '';
                  }
                });
              },
              icon: Icon(_isSearchExpanded ? Icons.close : Icons.search),
            ),
            // Stats screen
            IconButton(
              onPressed: () {
                context.push('/stats');
              },
              icon: const Icon(Icons.analytics),
              tooltip: 'View Statistics',
            ),
            // Demo screen
            IconButton(
              onPressed: () {
                context.push('/demo');
              },
              icon: const Icon(Icons.code),
              tooltip: 'Riverpod Demo',
            ),
            // Dark mode toggle
            IconButton(
              onPressed: () {
                ref.read(darkModeProvider.notifier).state = !darkMode;
              },
              icon: Icon(darkMode ? Icons.light_mode : Icons.dark_mode),
            ),
            // Logout button
            const LogoutButton(),
          ],
          bottom: _isSearchExpanded
              ? PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search todos...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(searchQueryProvider.notifier).state = '';
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                },
              ),
            ),
          )
              : null,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await ref.read(todoListProvider(user.id).notifier).refreshTodos();
          },
          child: Column(
            children: [
              // Stats Cards
              _buildStatsCards(todoStats, darkMode),

              // Filter Chips
              _buildFilterChips(darkMode),

              // Todo Count Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Text(
                      'Todos: $todoCount',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: darkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    // Sort dropdown
                    DropdownButton<SortOrder>(
                      value: ref.watch(sortOrderProvider),
                      items: SortOrder.values.map((order) {
                        return DropdownMenuItem(
                          value: order,
                          child: Text(_getSortOrderText(order)),
                        );
                      }).toList(),
                      onChanged: (order) {
                        if (order != null) {
                          ref.read(sortOrderProvider.notifier).state = order;
                        }
                      },
                    ),
                  ],
                ),
              ),

              // Todo List
              Expanded(
                child: todos.isEmpty
                    ? _buildEmptyState(darkMode)
                    : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return _buildTodoCard(todo, darkMode, user.id);
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.push('/add-todo');
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Todo'),
          backgroundColor: darkMode ? Colors.blue[600] : Colors.blue[500],
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildStatsCards(AsyncValue<TodoStats> todoStats, bool darkMode) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      child: todoStats.when(
        data: (stats) => ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _buildStatCard('Total', stats.total, Colors.blue, darkMode),
            _buildStatCard(
              'Completed',
              stats.completed,
              Colors.green,
              darkMode,
            ),
            _buildStatCard('Pending', stats.pending, Colors.orange, darkMode),
            _buildStatCard(
              'In Progress',
              stats.inProgress,
              Colors.purple,
              darkMode,
            ),
            _buildStatCard('Overdue', stats.overdue, Colors.red, darkMode),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error loading stats: $error',
            style: TextStyle(
              color: darkMode ? Colors.red[300] : Colors.red[700],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, int count, Color color, bool darkMode) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: darkMode ? Colors.grey[800] : Colors.white,
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
    );
  }

  Widget _buildFilterChips(bool darkMode) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('All', null, darkMode),
          _buildFilterChip('Pending', TodoStatus.pending, darkMode),
          _buildFilterChip('In Progress', TodoStatus.inProgress, darkMode),
          _buildFilterChip('Completed', TodoStatus.completed, darkMode),
          _buildFilterChip('High Priority', TodoPriority.high, darkMode),
          _buildFilterChip('Medium Priority', TodoPriority.medium, darkMode),
          _buildFilterChip('Low Priority', TodoPriority.low, darkMode),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, dynamic value, bool darkMode) {
    final isSelected =
        ref.watch(selectedFilterProvider) == value ||
            ref.watch(selectedPriorityProvider) == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (value is TodoStatus) {
            ref.read(selectedFilterProvider.notifier).state = selected
                ? value
                : null;
            ref.read(selectedPriorityProvider.notifier).state = null;
          } else if (value is TodoPriority) {
            ref.read(selectedPriorityProvider.notifier).state = selected
                ? value
                : null;
            ref.read(selectedFilterProvider.notifier).state = null;
          } else {
            ref.read(selectedFilterProvider.notifier).state = null;
            ref.read(selectedPriorityProvider.notifier).state = null;
          }
        },
        backgroundColor: darkMode ? Colors.grey[700] : Colors.grey[200],
        selectedColor: darkMode ? Colors.blue[600] : Colors.blue[200],
        labelStyle: TextStyle(
          color: isSelected
              ? Colors.white
              : (darkMode ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  Widget _buildTodoCard(Todo todo, bool darkMode, String userId) {
    final isOverdue =
        todo.dueDate != null &&
            todo.dueDate!.isBefore(DateTime.now()) &&
            todo.status != TodoStatus.completed;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: darkMode ? Colors.grey[800] : Colors.white,
      child: ListTile(
        leading: Checkbox(
          value: todo.status == TodoStatus.completed,
          onChanged: (value) {
            ref
                .read(todoListProvider(userId).notifier)
                .toggleTodoStatus(todo.id);
          },
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.status == TodoStatus.completed
                ? TextDecoration.lineThrough
                : null,
            fontWeight: FontWeight.bold,
            color: darkMode ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todo.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: darkMode ? Colors.grey[300] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildPriorityChip(todo.priority, darkMode),
                const SizedBox(width: 8),
                _buildStatusChip(todo.status, darkMode),
                if (isOverdue) ...[
                  const SizedBox(width: 8),
                  _buildOverdueChip(darkMode),
                ],
              ],
            ),
            if (todo.tags.isNotEmpty) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                children: todo.tags
                    .map(
                      (tag) => Chip(
                    label: Text(tag),
                    backgroundColor: darkMode
                        ? Colors.grey[700]
                        : Colors.grey[200],
                    labelStyle: TextStyle(
                      fontSize: 10,
                      color: darkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                )
                    .toList(),
              ),
            ],
            if (todo.dueDate != null) ...[
              const SizedBox(height: 4),
              Text(
                'Due: ${DateFormat('MMM dd, yyyy').format(todo.dueDate!)}',
                style: TextStyle(
                  fontSize: 12,
                  color: isOverdue
                      ? Colors.red
                      : (darkMode ? Colors.grey[400] : Colors.grey[600]),
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
              child: const Row(
                children: [Icon(Icons.edit), SizedBox(width: 8), Text('Edit')],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: const Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              context.push('/edit-todo/${todo.id}');
            } else if (value == 'delete') {
              _showDeleteDialog(todo, userId);
            }
          },
        ),
        onTap: () {
          context.push('/edit-todo/${todo.id}');
        },
      ),
    );
  }

  Widget _buildPriorityChip(TodoPriority priority, bool darkMode) {
    Color color;
    switch (priority) {
      case TodoPriority.high:
        color = Colors.red;
        break;
      case TodoPriority.medium:
        color = Colors.orange;
        break;
      case TodoPriority.low:
        color = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        priority.name.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildStatusChip(TodoStatus status, bool darkMode) {
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildOverdueChip(bool darkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red),
      ),
      child: const Text(
        'OVERDUE',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool darkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 80,
            color: darkMode ? Colors.grey[600] : Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No todos found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkMode ? Colors.grey[300] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first todo',
            style: TextStyle(
              color: darkMode ? Colors.grey[400] : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Todo todo, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Todo'),
        content: Text('Are you sure you want to delete "${todo.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref
                    .read(todoListProvider(userId).notifier)
                    .deleteTodo(todo.id);
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
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
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
