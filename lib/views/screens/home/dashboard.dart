import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../controllers/mood_controller.dart';
import '../../../controllers/task_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../views/widgets/calendar_strip.dart';
import '../../../views/widgets/mood_indicator.dart';
import '../../../views/widgets/task_list.dart';
import '../task/task_creation_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateTime _focusedDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadTasksForDate(_selectedDate);
  }

  Future<void> _loadTasksForDate(DateTime date) async {
    final taskController = Provider.of<TaskController>(context, listen: false);
    await taskController.loadTasksByDate(date);
  }

  void _onDateSelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      _selectedDate = selectedDate;
      _focusedDate = focusedDate;
    });
    _loadTasksForDate(selectedDate);
  }

  void _showTaskCreationScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskCreationScreen(
          initialDate: _selectedDate,
        ),
      ),
    );
  }

  void _showCalendarView() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildCalendarModal(),
    );
  }

  Widget _buildCalendarModal() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grayDisabled,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Calendar
          Expanded(
            child: Consumer<TaskController>(
              builder: (context, taskController, child) {
                return TableCalendar<String>(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDate,
                  selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    _onDateSelected(selectedDay, focusedDay);
                    Navigator.of(context).pop();
                  },
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    markersMaxCount: 3,
                    markerDecoration: const BoxDecoration(
                      color: AppColors.primaryOrange,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: AppColors.primaryOrange,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: AppColors.primaryOrange.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                  eventLoader: (day) {
                    // Return task indicators for days with tasks
                    final tasksForDay = taskController.allTasks
                        .where((task) => isSameDay(task.date, day))
                        .toList();
                    return tasksForDay
                        .map((task) => task.id.toString())
                        .toList();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBeige,
      appBar: AppBar(
        backgroundColor: AppColors.creamBeige,
        elevation: 0,
        title: Row(
          children: [
            GestureDetector(
              onTap: _showCalendarView,
              child: Row(
                children: [
                  Text(
                    '${_getMonthName(_focusedDate.month)} ${_focusedDate.year}',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.primaryText,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Consumer<MoodController>(
            builder: (context, moodController, child) {
              return MoodIndicator(
                mood: moodController.selectedMood,
                onTap: () {
                  // Navigate to mood selection or show mood picker
                  _showMoodPicker();
                },
              );
            },
          ),
          const SizedBox(width: AppConstants.paddingMedium),
        ],
      ),
      body: Column(
        children: [
          // Calendar Strip
          CalendarStrip(
            selectedDate: _selectedDate,
            focusedDate: _focusedDate,
            onDateSelected: _onDateSelected,
          ),

          const SizedBox(height: AppConstants.paddingMedium),

          // Task List
          Expanded(
            child: Consumer<TaskController>(
              builder: (context, taskController, child) {
                if (taskController.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryOrange),
                    ),
                  );
                }

                return TaskList(
                  tasks: taskController.tasks,
                  selectedDate: _selectedDate,
                  onTaskToggle: (taskId) =>
                      taskController.toggleTaskCompletion(taskId),
                  onTaskFavorite: (taskId) =>
                      taskController.toggleTaskFavorite(taskId),
                  onTaskDelete: (taskId) => taskController.deleteTask(taskId),
                  onTaskEdit: (task) {
                    // Navigate to task edit screen
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TaskCreationScreen(
                          initialDate: _selectedDate,
                          taskToEdit: task,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTaskCreationScreen,
        backgroundColor: AppColors.primaryOrange,
        child: const Icon(
          Icons.add,
          color: AppColors.lightText,
          size: 28,
        ),
      ),
    );
  }

  void _showMoodPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grayDisabled,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Text(
              'How are you feeling?',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
            ),

            const SizedBox(height: AppConstants.paddingLarge),

            Consumer<MoodController>(
              builder: (context, moodController, child) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: moodController.moods.length,
                  itemBuilder: (context, index) {
                    final mood = moodController.moods[index];
                    return GestureDetector(
                      onTap: () {
                        moodController.selectMood(mood);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.getMoodColor(mood.name),
                          borderRadius: BorderRadius.circular(16),
                          border: moodController.isMoodSelected(mood)
                              ? Border.all(
                                  color: AppColors.primaryOrange, width: 3)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            mood.emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
