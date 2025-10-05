import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/providers.dart';
import '../../models/todo.dart';

class AddEditTodoScreen extends ConsumerStatefulWidget {
  final String? todoId;

  const AddEditTodoScreen({super.key, this.todoId});

  @override
  ConsumerState<AddEditTodoScreen> createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends ConsumerState<AddEditTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();

  TodoPriority _selectedPriority = TodoPriority.medium;
  TodoStatus _selectedStatus = TodoStatus.pending;
  DateTime? _selectedDueDate;
  List<String> _tags = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.todoId != null) {
      _loadTodo();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _loadTodo() async {
    final authState = ref.read(authStateProvider);
    if (!authState.isAuthenticated) return;

    final todos = ref.read(todoListProvider(authState.user!.id));
    final todo = todos.firstWhere((t) => t.id == widget.todoId);

    setState(() {
      _titleController.text = todo.title;
      _descriptionController.text = todo.description;
      _selectedPriority = todo.priority;
      _selectedStatus = todo.status;
      _selectedDueDate = todo.dueDate;
      _tags = List.from(todo.tags);
      _tagsController.text = _tags.join(', ');
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final darkMode = ref.watch(darkModeProvider);

    if (!authState.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/login');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Theme(
      data: Theme.of(
        context,
      ).copyWith(brightness: darkMode ? Brightness.dark : Brightness.light),
      child: Scaffold(
        backgroundColor: darkMode ? Colors.grey[900] : Colors.grey[50],
        appBar: AppBar(
          title: Text(widget.todoId == null ? 'Add Todo' : 'Edit Todo'),
          backgroundColor: darkMode ? Colors.grey[800] : Colors.blue[600],
          foregroundColor: Colors.white,
          actions: [
            TextButton(
              onPressed: _isLoading ? null : _saveTodo,
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title Field
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title *',
                        hintText: 'Enter todo title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.title),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Description Field
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description *',
                        hintText: 'Enter todo description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.description),
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Description is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Priority and Status Row
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Priority',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<TodoPriority>(
                                value: _selectedPriority,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                items: TodoPriority.values.map((priority) {
                                  return DropdownMenuItem(
                                    value: priority,
                                    child: Row(
                                      children: [
                                        _getPriorityIcon(priority),
                                        const SizedBox(width: 8),
                                        Text(priority.name.toUpperCase()),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedPriority = value;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Status',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<TodoStatus>(
                                value: _selectedStatus,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                items: TodoStatus.values.map((status) {
                                  return DropdownMenuItem(
                                    value: status,
                                    child: Row(
                                      children: [
                                        _getStatusIcon(status),
                                        const SizedBox(width: 8),
                                        Text(status.name.toUpperCase()),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedStatus = value;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Due Date
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Due Date',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: _selectDueDate,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today),
                                const SizedBox(width: 8),
                                Text(
                                  _selectedDueDate != null
                                      ? DateFormat(
                                    'MMM dd, yyyy',
                                  ).format(_selectedDueDate!)
                                      : 'Select due date',
                                  style: TextStyle(
                                    color: _selectedDueDate != null
                                        ? null
                                        : Colors.grey[600],
                                  ),
                                ),
                                const Spacer(),
                                if (_selectedDueDate != null)
                                  IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        _selectedDueDate = null;
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Tags
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tags',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _tagsController,
                          decoration: InputDecoration(
                            hintText: 'Enter tags separated by commas',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.tag),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: _addTags,
                            ),
                          ),
                          onFieldSubmitted: (_) => _addTags(),
                        ),
                        if (_tags.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: _tags
                                .map(
                                  (tag) => Chip(
                                label: Text(tag),
                                deleteIcon: const Icon(
                                  Icons.close,
                                  size: 16,
                                ),
                                onDeleted: () {
                                  setState(() {
                                    _tags.remove(tag);
                                    _tagsController.text = _tags.join(', ');
                                  });
                                },
                              ),
                            )
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Save Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveTodo,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  )
                      : Text(
                    widget.todoId == null ? 'Create Todo' : 'Update Todo',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getPriorityIcon(TodoPriority priority) {
    IconData iconData;
    Color color;

    switch (priority) {
      case TodoPriority.high:
        iconData = Icons.keyboard_arrow_up;
        color = Colors.red;
        break;
      case TodoPriority.medium:
        iconData = Icons.remove;
        color = Colors.orange;
        break;
      case TodoPriority.low:
        iconData = Icons.keyboard_arrow_down;
        color = Colors.green;
        break;
    }

    return Icon(iconData, color: color, size: 20);
  }

  Widget _getStatusIcon(TodoStatus status) {
    IconData iconData;
    Color color;

    switch (status) {
      case TodoStatus.pending:
        iconData = Icons.schedule;
        color = Colors.grey;
        break;
      case TodoStatus.inProgress:
        iconData = Icons.play_circle;
        color = Colors.blue;
        break;
      case TodoStatus.completed:
        iconData = Icons.check_circle;
        color = Colors.green;
        break;
    }

    return Icon(iconData, color: color, size: 20);
  }

  Future<void> _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _selectedDueDate = date;
      });
    }
  }

  void _addTags() {
    final tagsText = _tagsController.text.trim();
    if (tagsText.isNotEmpty) {
      final newTags = tagsText
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();
      setState(() {
        _tags.addAll(newTags);
        _tags = _tags.toSet().toList(); // Remove duplicates
        _tagsController.clear();
      });
    }
  }

  Future<void> _saveTodo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authState = ref.read(authStateProvider);
      final userId = authState.user!.id;

      if (widget.todoId == null) {
        // Create new todo
        await ref
            .read(todoListProvider(userId).notifier)
            .addTodo(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          priority: _selectedPriority,
          dueDate: _selectedDueDate,
          tags: _tags,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Todo created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        }
      } else {
        // Update existing todo
        final todos = ref.read(todoListProvider(userId));
        final todo = todos.firstWhere((t) => t.id == widget.todoId);

        final updatedTodo = todo.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          priority: _selectedPriority,
          status: _selectedStatus,
          dueDate: _selectedDueDate,
          tags: _tags,
        );

        await ref
            .read(todoListProvider(userId).notifier)
            .updateTodo(updatedTodo);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Todo updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving todo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
