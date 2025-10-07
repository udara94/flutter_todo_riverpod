import 'dart:ui';
import 'package:flutter/material.dart';
import '../../entity/todo.dart';
import '../../utils/constants/app_colors.dart';

/// Common bottom sheet component for selecting priority or status
class SelectionBottomSheet {
  /// Show priority selection bottom sheet
  static Future<TodoPriority?> showPrioritySelection(
    BuildContext context, {
    required TodoPriority currentPriority,
  }) async {
    return await _showSelectionBottomSheet<TodoPriority>(
      context,
      title: 'Select Priority',
      currentValue: currentPriority,
      options: TodoPriority.values,
      getDisplayText: (priority) => _getPriorityText(priority),
      getIcon: (priority) => _getPriorityIcon(priority),
      getColor: (priority) => _getPriorityColor(priority),
    );
  }

  /// Show status selection bottom sheet
  static Future<TodoStatus?> showStatusSelection(
    BuildContext context, {
    required TodoStatus currentStatus,
  }) async {
    return await _showSelectionBottomSheet<TodoStatus>(
      context,
      title: 'Select Status',
      currentValue: currentStatus,
      options: TodoStatus.values,
      getDisplayText: (status) => _getStatusText(status),
      getIcon: (status) => _getStatusIcon(status),
      getColor: (status) => _getStatusColor(status),
    );
  }

  /// Generic bottom sheet for any enum selection
  static Future<T?> _showSelectionBottomSheet<T>(
    BuildContext context, {
    required String title,
    required T currentValue,
    required List<T> options,
    required String Function(T) getDisplayText,
    required IconData Function(T) getIcon,
    required Color Function(T) getColor,
  }) async {
    return await showModalBottomSheet<T>(
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
              color: AppColors.surfaceLight.withOpacity(0.4),
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
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Text(
                    title,
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
                  ),
                ),
                const SizedBox(height: 20),
                // Options list
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final isSelected = option == currentValue;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(option),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? getColor(option).withOpacity(0.3)
                                    : getColor(option).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? getColor(option)
                                      : getColor(option).withOpacity(0.7),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    getIcon(option),
                                    color: getColor(option),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      getDisplayText(option),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black54,
                                            blurRadius: 2,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle,
                                      color: getColor(option),
                                      size: 20,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Priority helper methods
  static String _getPriorityText(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.high:
        return 'High Priority';
      case TodoPriority.medium:
        return 'Medium Priority';
      case TodoPriority.low:
        return 'Low Priority';
    }
  }

  static IconData _getPriorityIcon(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.high:
        return Icons.keyboard_arrow_up;
      case TodoPriority.medium:
        return Icons.remove;
      case TodoPriority.low:
        return Icons.keyboard_arrow_down;
    }
  }

  static Color _getPriorityColor(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.high:
        return AppColors.priorityHigh;
      case TodoPriority.medium:
        return AppColors.priorityMedium;
      case TodoPriority.low:
        return AppColors.priorityLow;
    }
  }

  // Status helper methods
  static String _getStatusText(TodoStatus status) {
    switch (status) {
      case TodoStatus.pending:
        return 'Pending';
      case TodoStatus.inProgress:
        return 'In Progress';
      case TodoStatus.completed:
        return 'Completed';
    }
  }

  static IconData _getStatusIcon(TodoStatus status) {
    switch (status) {
      case TodoStatus.pending:
        return Icons.schedule;
      case TodoStatus.inProgress:
        return Icons.play_circle_outline;
      case TodoStatus.completed:
        return Icons.check_circle_outline;
    }
  }

  static Color _getStatusColor(TodoStatus status) {
    switch (status) {
      case TodoStatus.pending:
        return Colors.grey;
      case TodoStatus.inProgress:
        return Colors.blue;
      case TodoStatus.completed:
        return Colors.green;
    }
  }
}
