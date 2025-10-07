import 'package:flutter/material.dart';

import '../../models/task.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const TaskItem({
    super.key,
    required this.task,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Row(
              children: [
                // Task Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.getTaskIconColor(task.iconColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getIconData(task.iconType),
                    color: AppColors.lightText,
                    size: 20,
                  ),
                ),

                const SizedBox(width: AppConstants.paddingMedium),

                // Task Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Task Title
                      Text(
                        task.title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: task.isCompleted
                                  ? AppColors.secondaryText
                                  : AppColors.primaryText,
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Task Description (if available)
                      if (task.description != null &&
                          task.description!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            task.description!,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.secondaryText,
                                    ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),

                // Task Status Icons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Favorite Icon
                    if (task.isFavorite)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: const Icon(
                          Icons.star,
                          color: AppColors.yellowTask,
                          size: 20,
                        ),
                      ),

                    // Completion Status
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: task.isCompleted
                            ? AppColors.greenTask
                            : Colors.transparent,
                        border: task.isCompleted
                            ? null
                            : Border.all(
                                color: AppColors.grayDisabled, width: 2),
                      ),
                      child: task.isCompleted
                          ? const Icon(
                              Icons.check,
                              color: AppColors.lightText,
                              size: 16,
                            )
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconType) {
    switch (iconType.toLowerCase()) {
      case 'education':
        return Icons.school;
      case 'shopping':
        return Icons.shopping_cart;
      case 'finance':
        return Icons.account_balance_wallet;
      case 'food':
        return Icons.restaurant;
      case 'cleaning':
        return Icons.cleaning_services;
      case 'document':
        return Icons.description;
      case 'message':
        return Icons.message;
      case 'music':
        return Icons.music_note;
      case 'entertainment':
        return Icons.movie;
      case 'update':
        return Icons.system_update;
      case 'health':
        return Icons.health_and_safety;
      case 'work':
        return Icons.work;
      case 'exercise':
        return Icons.fitness_center;
      case 'travel':
        return Icons.travel_explore;
      case 'hobby':
        return Icons.palette;
      default:
        return Icons.task_alt;
    }
  }
}
