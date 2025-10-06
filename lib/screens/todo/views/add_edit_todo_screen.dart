import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../entity/todo.dart';
import '../controllers/todo_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/enum/auth_state.dart';
import '../../../utils/constants/app_dimensions.dart';
import '../../../generated/l10n.dart';
import '../../../utils/router/app_router.dart';
import '../../../utils/snackbar_util.dart';
import '../../../widgets/common/app_text_input_field.dart';
import '../../../widgets/common/app_button.dart';

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
    final authState = ref.read(authControllerProvider);
    if (authState?.status != AuthStatus.authenticated) return;

    final todoState = ref.read(todoControllerProvider);
    final todo = todoState.todos.firstWhere((t) => t.id == widget.todoId);

    setState(() {
      _titleController.text = todo.title;
      _descriptionController.text = todo.description;
      _selectedPriority = todo.priority;
      _selectedStatus = todo.status;
      _selectedDueDate = todo.dueDate;
      _tags =
          todo.tags
              ?.split(',')
              .map((tag) => tag.trim())
              .where((tag) => tag.isNotEmpty)
              .toList() ??
          [];
      _tagsController.text = _tags.join(', ');
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    if (authState?.status != AuthStatus.authenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppRouter.goToLogin(context);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.todoId == null ? S.current.addNewTask : S.current.editTask,
        ),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          AppButton(
            text: S.current.saveTask,
            onPressed: _isLoading ? null : _saveTodo,
            variant: AppButtonVariant.primary,
            size: AppButtonSize.medium,
            isLoading: _isLoading,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.paddingAllL,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title Field
              Card(
                child: Padding(
                  padding: AppDimensions.paddingAllL,
                  child: AppTextInputField(
                    controller: _titleController,
                    labelText: S.current.todoTitle,
                    hintText: S.current.taskTitleHint,
                    prefixIcon: Icons.title,
                    isRequired: true,
                    requiredErrorMessage: '${S.current.todoTitle} is required',
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.spacingL),

              // Description Field
              Card(
                child: Padding(
                  padding: AppDimensions.paddingAllL,
                  child: AppTextInputField(
                    controller: _descriptionController,
                    labelText: S.current.todoDescription,
                    hintText: S.current.taskDescriptionHint,
                    prefixIcon: Icons.description,
                    maxLines: 4,
                    isRequired: true,
                    requiredErrorMessage:
                        '${S.current.todoDescription} is required',
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.spacingL),

              // Priority and Status Row
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: AppDimensions.paddingAllL,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.current.todoPriority,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppDimensions.fontSizeL,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacingS),
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
                                      Text(_getPriorityText(priority)),
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
                        padding: AppDimensions.paddingAllL,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.current.todoStatus,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppDimensions.fontSizeL,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacingS),
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
                                      Text(_getStatusText(status)),
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

              const SizedBox(height: AppDimensions.spacingL),

              // Due Date
              Card(
                child: Padding(
                  padding: AppDimensions.paddingAllL,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.current.todoDueDate,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppDimensions.fontSizeL,
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

              const SizedBox(height: AppDimensions.spacingL),

              // Tags
              Card(
                child: Padding(
                  padding: AppDimensions.paddingAllL,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.current.todoTags,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppDimensions.fontSizeL,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AppTextInputField(
                        controller: _tagsController,
                        hintText: S.current.tagsHint,
                        prefixIcon: Icons.tag,
                        suffixIcon: Icons.add,
                        onSuffixIconPressed: _addTags,
                        onSubmitted: (_) => _addTags(),
                        borderRadius: 8.0,
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
                                  deleteIcon: const Icon(Icons.close, size: 16),
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
              AppButton(
                text: widget.todoId == null
                    ? S.current.addNewTask
                    : S.current.editTask,
                onPressed: _isLoading ? null : _saveTodo,
                variant: AppButtonVariant.primary,
                size: AppButtonSize.large,
                isLoading: _isLoading,
                isFullWidth: true,
              ),
            ],
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
      final authState = ref.read(authControllerProvider);
      final userId = authState!.user!.id;

      if (widget.todoId == null) {
        // Create new todo
        await ref
            .read(todoControllerProvider.notifier)
            .addTodo(
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              priority: _selectedPriority,
              userId: userId,
              dueDate: _selectedDueDate,
              tags: _tags,
            );

        if (mounted) {
          SnackBarUtil.showSuccess(context, 'Todo created successfully!');
          context.pop();
        }
      } else {
        // Update existing todo
        final todoState = ref.read(todoControllerProvider);
        final todo = todoState.todos.firstWhere((t) => t.id == widget.todoId);

        final updatedTodo = todo.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          priority: _selectedPriority,
          status: _selectedStatus,
          dueDate: _selectedDueDate,
          tags: _tags.join(','),
        );

        await ref.read(todoControllerProvider.notifier).updateTodo(updatedTodo);

        if (mounted) {
          SnackBarUtil.showSuccess(context, 'Todo updated successfully!');
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtil.showError(context, 'Error saving todo: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getPriorityText(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.low:
        return S.current.priorityLow;
      case TodoPriority.medium:
        return S.current.priorityMedium;
      case TodoPriority.high:
        return S.current.priorityHigh;
    }
  }

  String _getStatusText(TodoStatus status) {
    switch (status) {
      case TodoStatus.pending:
        return S.current.statusPending;
      case TodoStatus.inProgress:
        return S.current.statusInProgress;
      case TodoStatus.completed:
        return S.current.statusCompleted;
    }
  }
}
