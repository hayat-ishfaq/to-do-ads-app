import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final Function(bool?) onToggleComplete;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onTap,
    required this.onDelete,
    required this.onToggleComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Completion checkbox
                  Checkbox(
                    value: task.isCompleted,
                    onChanged: onToggleComplete,
                    activeColor: theme.primaryColor,
                  ),

                  // Task title
                  Expanded(
                    child: Text(
                      task.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: task.isCompleted
                            ? theme.textTheme.bodyMedium?.color?.withOpacity(
                                0.6,
                              )
                            : null,
                      ),
                    ),
                  ),

                  // Priority chip
                  _buildPriorityChip(task.priority, theme),

                  const SizedBox(width: 8),

                  // Delete button
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red,
                    tooltip: 'Delete task',
                  ),
                ],
              ),

              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  task.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: task.isCompleted
                        ? theme.textTheme.bodyMedium?.color?.withOpacity(0.6)
                        : theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 8),

              // Date and time
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDateTime(task.date),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _getDateColor(task.date, task.isCompleted, theme),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityChip(String priority, ThemeData theme) {
    Color chipColor;
    Color textColor = Colors.white;

    switch (priority.toLowerCase()) {
      case 'high':
        chipColor = Colors.red;
        break;
      case 'medium':
        chipColor = Colors.orange;
        break;
      case 'low':
        chipColor = Colors.green;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Chip(
      label: Text(
        priority,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: chipColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final taskDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dateStr;
    if (taskDate == today) {
      dateStr = 'Today';
    } else if (taskDate == tomorrow) {
      dateStr = 'Tomorrow';
    } else if (taskDate.isBefore(today)) {
      final difference = today.difference(taskDate).inDays;
      dateStr = '$difference day${difference > 1 ? 's' : ''} ago';
    } else {
      dateStr = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }

    final timeStr =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$dateStr at $timeStr';
  }

  Color _getDateColor(DateTime date, bool isCompleted, ThemeData theme) {
    if (isCompleted) {
      return theme.textTheme.bodySmall?.color?.withOpacity(0.6) ?? Colors.grey;
    }

    final now = DateTime.now();
    if (date.isBefore(now)) {
      return Colors.red; // Overdue
    } else if (date.difference(now).inHours < 24) {
      return Colors.orange; // Due soon
    } else {
      return theme.textTheme.bodySmall?.color?.withOpacity(0.8) ?? Colors.grey;
    }
  }
}
