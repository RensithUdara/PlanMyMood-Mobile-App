import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../models/task.dart';
import '../../utils/app_colors.dart';

class AnimatedTaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onTaskTap;
  final Function(Task) onTaskCompleted;
  final Function(Task) onTaskFavorited;
  final Function(Task) onTaskDeleted;

  const AnimatedTaskList({
    super.key,
    required this.tasks,
    required this.onTaskTap,
    required this.onTaskCompleted,
    required this.onTaskFavorited,
    required this.onTaskDeleted,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return EmptyTasksWidget().animate().fadeIn(duration: 500.ms);
    }

    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];

          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: TaskCard(
                  task: task,
                  onTap: () => onTaskTap(task),
                  onCompleted: () => onTaskCompleted(task),
                  onFavorited: () => onTaskFavorited(task),
                  onDeleted: () => onTaskDeleted(task),
                )
                    .animate()
                    .scale(
                      duration: 200.ms,
                      curve: Curves.easeInOut,
                    )
                    .then()
                    .shimmer(duration: 1000.ms, colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.1),
                  Colors.transparent,
                ]),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TaskCard extends StatefulWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onCompleted;
  final VoidCallback onFavorited;
  final VoidCallback onDeleted;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onCompleted,
    required this.onFavorited,
    required this.onDeleted,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              child: Card(
                elevation: widget.task.isCompleted ? 2 : 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: widget.task.isCompleted
                        ? LinearGradient(
                            colors: [
                              Colors.grey[100]!,
                              Colors.grey[200]!,
                            ],
                          )
                        : LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.grey[50]!,
                            ],
                          ),
                  ),
                  child: Row(
                    children: [
                      // Task Icon
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Color(int.parse(widget.task.iconColor
                                  .replaceAll('#', '0xFF')))
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getIconForType(widget.task.iconType),
                          color: Color(int.parse(
                              widget.task.iconColor.replaceAll('#', '0xFF'))),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Task Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.task.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    decoration: widget.task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: widget.task.isCompleted
                                        ? Colors.grey[600]
                                        : null,
                                  ),
                            ),
                            if (widget.task.description != null &&
                                widget.task.description!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                widget.task.description!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Action Buttons
                      Column(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            child: IconButton(
                              icon: Icon(
                                widget.task.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: widget.task.isFavorite
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                              onPressed: widget.onFavorited,
                            ),
                          )
                              .animate(target: widget.task.isFavorite ? 1 : 0)
                              .scale(duration: 200.ms),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            child: IconButton(
                              icon: Icon(
                                widget.task.isCompleted
                                    ? Icons.check_circle
                                    : Icons.check_circle_outline,
                                color: widget.task.isCompleted
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              onPressed: widget.onCompleted,
                            ),
                          )
                              .animate(target: widget.task.isCompleted ? 1 : 0)
                              .scale(duration: 200.ms),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getIconForType(String iconType) {
    switch (iconType) {
      case 'work':
        return Icons.work;
      case 'personal':
        return Icons.person;
      case 'health':
        return Icons.health_and_safety;
      case 'education':
        return Icons.school;
      case 'shopping':
        return Icons.shopping_cart;
      case 'finance':
        return Icons.attach_money;
      case 'food':
        return Icons.restaurant;
      case 'entertainment':
        return Icons.movie;
      default:
        return Icons.task;
    }
  }
}

class EmptyTasksWidget extends StatelessWidget {
  const EmptyTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
              color: AppColors.primaryOrange,
            ),
          )
              .animate()
              .scale(duration: 600.ms, curve: Curves.elasticOut)
              .then()
              .shimmer(duration: 2000.ms),
          const SizedBox(height: 24),
          Text(
            'No tasks yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.bold,
                ),
          ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
          const SizedBox(height: 8),
          Text(
            'Create your first task to get started!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondaryText,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 500.ms, duration: 500.ms),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // This would trigger the FAB action
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Task'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOrange,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 700.ms, duration: 500.ms)
              .slideY(begin: 0.3, delay: 700.ms, duration: 500.ms),
        ],
      ),
    );
  }
}
