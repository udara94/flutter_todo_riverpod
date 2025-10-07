import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../entity/todo.dart';
import '../controllers/todo_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/enum/auth_state.dart';
import '../../../utils/constants/app_dimensions.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../generated/l10n.dart';
import '../../../utils/router/app_router.dart';
import '../../../utils/snackbar_util.dart';
import '../../../widgets/common/app_text_input_field.dart';
import '../../../widgets/common/app_button.dart';
import '../../../widgets/common/selection_bottom_sheet.dart';

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
            title: Text(
              widget.todoId == null ? S.current.addNewTask : S.current.editTask,
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              // Padding(
              //   padding: const EdgeInsets.only(right: 16.0),
              //   child: AppButton(
              //     text: S.current.saveTask,
              //     onPressed: _isLoading ? null : _saveTodo,
              //     variant: AppButtonVariant.primary,
              //     size: AppButtonSize.medium,
              //     isLoading: _isLoading,
              //   ),
              // ),
            ],
          ),
        ),
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

              // Priority and Status Column
              Column(
                children: [
                  // Priority Card
                  Card(
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
                          InkWell(
                            onTap: () async {
                              final selectedPriority =
                                  await SelectionBottomSheet.showPrioritySelection(
                                    context,
                                    currentPriority: _selectedPriority,
                                  );
                              if (selectedPriority != null) {
                                setState(() {
                                  _selectedPriority = selectedPriority;
                                });
                              }
                            },
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusS,
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.spacingM,
                                vertical: AppDimensions.spacingL,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.grey300),
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusS,
                                ),
                              ),
                              child: Row(
                                children: [
                                  _getPriorityIcon(_selectedPriority),
                                  SizedBox(width: AppDimensions.spacingS),
                                  Text(_getPriorityText(_selectedPriority)),
                                  const Spacer(),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColors.grey600,
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

                  // Status Card
                  Card(
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
                          InkWell(
                            onTap: () async {
                              final selectedStatus =
                                  await SelectionBottomSheet.showStatusSelection(
                                    context,
                                    currentStatus: _selectedStatus,
                                  );
                              if (selectedStatus != null) {
                                setState(() {
                                  _selectedStatus = selectedStatus;
                                });
                              }
                            },
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusS,
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.spacingM,
                                vertical: AppDimensions.spacingL,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.grey300),
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusS,
                                ),
                              ),
                              child: Row(
                                children: [
                                  _getStatusIcon(_selectedStatus),
                                  SizedBox(width: AppDimensions.spacingS),
                                  Text(_getStatusText(_selectedStatus)),
                                  const Spacer(),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColors.grey600,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
                      SizedBox(height: AppDimensions.spacingS),
                      InkWell(
                        onTap: _selectDueDate,
                        child: Container(
                          padding: AppDimensions.paddingAllM,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.grey300),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusS,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today),
                              SizedBox(width: AppDimensions.spacingS),
                              Text(
                                _selectedDueDate != null
                                    ? DateFormat(
                                        'MMM dd, yyyy',
                                      ).format(_selectedDueDate!)
                                    : 'Select due date',
                                style: TextStyle(
                                  color: _selectedDueDate != null
                                      ? null
                                      : AppColors.grey600,
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
                      SizedBox(height: AppDimensions.spacingS),
                      AppTextInputField(
                        controller: _tagsController,
                        hintText: S.current.tagsHint,
                        prefixIcon: Icons.tag,
                        suffixIcon: Icons.add,
                        onSuffixIconPressed: _addTags,
                        onSubmitted: (_) => _addTags(),
                        borderRadius: AppDimensions.radiusS,
                      ),
                      if (_tags.isNotEmpty) ...[
                        SizedBox(height: AppDimensions.spacingS),
                        Wrap(
                          spacing: AppDimensions.spacingS,
                          runSpacing: AppDimensions.spacingXS,
                          children: _tags
                              .map(
                                (tag) => Chip(
                                  label: Text(tag),
                                  deleteIcon: Icon(
                                    Icons.close,
                                    size: AppDimensions.iconS,
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

              SizedBox(height: AppDimensions.spacingXXXL),

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
        color = AppColors.priorityHigh;
        break;
      case TodoPriority.medium:
        iconData = Icons.remove;
        color = AppColors.priorityMedium;
        break;
      case TodoPriority.low:
        iconData = Icons.keyboard_arrow_down;
        color = AppColors.priorityLow;
        break;
    }

    return Icon(iconData, color: color, size: AppDimensions.iconM);
  }

  Widget _getStatusIcon(TodoStatus status) {
    IconData iconData;
    Color color;

    switch (status) {
      case TodoStatus.pending:
        iconData = Icons.schedule;
        color = AppColors.todoPending;
        break;
      case TodoStatus.inProgress:
        iconData = Icons.play_circle;
        color = AppColors.todoInProgress;
        break;
      case TodoStatus.completed:
        iconData = Icons.check_circle;
        color = AppColors.todoCompleted;
        break;
    }

    return Icon(iconData, color: color, size: AppDimensions.iconM);
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
