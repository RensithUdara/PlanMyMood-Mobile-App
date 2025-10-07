import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../models/task.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import 'task_item.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final DateTime selectedDate;
  final Function(int) onTaskToggle;
  final Function(int) onTaskFavorite;
  final Function(int) onTaskDelete;
  final Function(Task) onTaskEdit;

  const TaskList({
    super.key,
    required this.tasks,
    required this.selectedDate,
    required this.onTaskToggle,
    required this.onTaskFavorite,
    required this.onTaskDelete,
    required this.onTaskEdit,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];

        return Slidable(
          key: ValueKey(task.id),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              // Complete/Uncomplete Action
              SlidableAction(
                onPressed: (context) => onTaskToggle(task.id!),
                backgroundColor: task.isCompleted
                    ? AppColors.grayDisabled
                    : AppColors.greenTask,
                foregroundColor: AppColors.lightText,
                icon: task.isCompleted ? Icons.undo : Icons.check,
                label: task.isCompleted ? 'Undo' : 'Done',
              ),

              // Favorite Action
              SlidableAction(
                onPressed: (context) => onTaskFavorite(task.id!),
                backgroundColor: task.isFavorite
                    ? AppColors.grayDisabled
                    : AppColors.yellowTask,
                foregroundColor: AppColors.lightText,
                icon: task.isFavorite ? Icons.star_border : Icons.star,
                label: task.isFavorite ? 'Unstar' : 'Star',
              ),

              // Edit Action
              SlidableAction(
                onPressed: (context) => onTaskEdit(task),
                backgroundColor: AppColors.cyanTask,
                foregroundColor: AppColors.lightText,
                icon: Icons.edit,
                label: 'Edit',
              ),

              // Delete Action
              SlidableAction(
                onPressed: (context) => _confirmDelete(context, task),
                backgroundColor: AppColors.angry,
                foregroundColor: AppColors.lightText,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: TaskItem(
            task: task,
            onTap: () => onTaskToggle(task.id!),
            onFavorite: () => onTaskFavorite(task.id!),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.lightCream,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.task_alt,
              size: 60,
              color: AppColors.grayDisabled,
            ),
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          Text(
            'No tasks for today',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            'Tap the + button to create your first task',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondaryText,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.secondaryText),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onTaskDelete(task.id!);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.angry),
            ),
          ),
        ],
      ),
    );
  }
}
