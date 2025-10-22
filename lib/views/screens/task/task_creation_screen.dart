import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../controllers/mood_controller.dart';
import '../../../controllers/task_controller.dart';
import '../../../models/mood.dart';
import '../../../models/task.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/validators.dart';
import '../../../views/widgets/mood_selector.dart';
import '../../../views/widgets/feedback_widgets.dart';
import '../../../views/widgets/loading_widget.dart';
import '../../../services/analytics_service.dart';

class TaskCreationScreen extends StatefulWidget {
  final DateTime initialDate;
  final Task? taskToEdit;

  const TaskCreationScreen({
    super.key,
    required this.initialDate,
    this.taskToEdit,
  });

  @override
  State<TaskCreationScreen> createState() => _TaskCreationScreenState();
}

class _TaskCreationScreenState extends State<TaskCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedIconType = 'task';
  String _selectedIconColor = '#9B8CE8';
  List<Mood> _selectedMoods = [];
  String _selectedReminderType = 'Once';

  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _isEditing = widget.taskToEdit != null;

    if (_isEditing) {
      _populateFieldsForEditing();
    }
  }

  void _populateFieldsForEditing() {
    final task = widget.taskToEdit!;
    _titleController.text = task.title;
    _descriptionController.text = task.description ?? '';
    _selectedDate = task.date;
    _selectedIconType = task.iconType;
    _selectedIconColor = task.iconColor;

    // Load selected moods
    final moodController = Provider.of<MoodController>(context, listen: false);
    _selectedMoods = moodController.getMoodsByIds(task.moodIds);
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primaryOrange,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _onMoodSelected(List<Mood> moods) {
    setState(() {
      _selectedMoods = moods;
    });
  }

  void _onIconColorSelected(String iconColor) {
    setState(() {
      _selectedIconColor = iconColor;
    });
  }

  void _onReminderTypeSelected(String reminderType) {
    setState(() {
      _selectedReminderType = reminderType;
    });
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final taskController =
          Provider.of<TaskController>(context, listen: false);

      final task = Task(
        id: _isEditing ? widget.taskToEdit!.id : null,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        iconType: _selectedIconType,
        iconColor: _selectedIconColor,
        date: _selectedDate,
        moodIds: _selectedMoods.map((mood) => mood.id!).toList(),
        createdAt: _isEditing ? widget.taskToEdit!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
      );

      bool success;
      if (_isEditing) {
        success = await taskController.updateTask(task);
      } else {
        final savedTask = await taskController.addTask(task);
        success = savedTask != null;
      }

      if (success) {
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_isEditing ? 'Task updated!' : 'Task created!'),
              backgroundColor: AppColors.greenTask,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save task'),
              backgroundColor: AppColors.angry,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.angry,
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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBeige,
      appBar: AppBar(
        backgroundColor: AppColors.creamBeige,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _isEditing ? 'Edit Task' : 'New Task',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          children: [
            // Task Input Section
            _buildTaskInputSection(),

            const SizedBox(height: AppConstants.paddingLarge),

            // Task Templates (only for new tasks)
            if (!_isEditing) _buildTaskTemplatesSection(),

            const SizedBox(height: AppConstants.paddingLarge),

            // When Section
            _buildWhenSection(),

            const SizedBox(height: AppConstants.paddingLarge),

            // Pick Moods Section
            _buildMoodsSection(),

            const SizedBox(height: AppConstants.paddingLarge),

            // Icon Selection Section
            _buildIconSection(),

            const SizedBox(height: AppConstants.paddingLarge),

            // Reminder Section
            _buildReminderSection(),

            const SizedBox(height: AppConstants.paddingXLarge),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveTask,
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.lightText),
                      )
                    : Text(
                        _isEditing ? 'Update task' : 'Create a task',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskInputSection() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
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
      child: Column(
        children: [
          // Task Title Input
          Row(
            children: [
              // Icon Placeholder
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.getTaskIconColor(_selectedIconColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.add_task,
                  color: AppColors.lightText,
                  size: 20,
                ),
              ),

              const SizedBox(width: AppConstants.paddingMedium),

              // Text Input
              Expanded(
                child: TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Write a task to do..',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a task title';
                    }
                    if (value.trim().length > AppConstants.maxTaskTitleLength) {
                      return 'Title too long (max ${AppConstants.maxTaskTitleLength} characters)';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),

          const Divider(height: 32),

          // Description Input
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              hintText: 'Add description (optional)',
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 3,
            validator: (value) {
              if (value != null &&
                  value.length > AppConstants.maxTaskDescriptionLength) {
                return 'Description too long (max ${AppConstants.maxTaskDescriptionLength} characters)';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTemplatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick suggestions',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        ...AppConstants.taskTemplates.map((template) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                child: InkWell(
                  onTap: () {
                    _titleController.text = template['title']!;
                    _selectedIconType = template['iconType']!;
                    _selectedIconColor = template['iconColor']!;
                    setState(() {});
                  },
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadius),
                  child: Container(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.getTaskIconColor(
                                template['iconColor']!),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            _getIconData(template['iconType']!),
                            color: AppColors.lightText,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: AppConstants.paddingMedium),
                        Expanded(
                          child: Text(
                            template['title']!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.primaryText,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildWhenSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'When?',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              border: Border.all(color: AppColors.mediumBeige),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: AppColors.primaryOrange,
                  size: 20,
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Text(
                  DateFormat('MMM dd, yyyy').format(_selectedDate),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.secondaryText,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoodsSection() {
    return Consumer<MoodController>(
      builder: (context, moodController, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pick moods',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            MoodSelector(
              moods: moodController.moods,
              selectedMoods: _selectedMoods,
              onMoodsChanged: _onMoodSelected,
            ),
          ],
        );
      },
    );
  }

  Widget _buildIconSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Icon & Color',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w600,
              ),
        ),

        const SizedBox(height: AppConstants.paddingMedium),

        // Color Selection
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: AppConstants.iconColors.map((color) {
            final isSelected = _selectedIconColor == color;
            return GestureDetector(
              onTap: () => _onIconColorSelected(color),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.getTaskIconColor(color),
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected
                      ? Border.all(color: AppColors.primaryOrange, width: 3)
                      : null,
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: AppColors.lightText,
                        size: 20,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildReminderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reminder',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        Row(
          children: AppConstants.reminderTypes.map((type) {
            final isSelected = _selectedReminderType == type;
            return Expanded(
              child: GestureDetector(
                onTap: () => _onReminderTypeSelected(type),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? AppColors.primaryOrange : AppColors.white,
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadius),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryOrange
                          : AppColors.mediumBeige,
                    ),
                  ),
                  child: Text(
                    type,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? AppColors.lightText
                              : AppColors.primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
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
      default:
        return Icons.task_alt;
    }
  }
}
