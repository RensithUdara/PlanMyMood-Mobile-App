import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../database/database_helper.dart';
import '../models/task.dart';

class TaskController extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  DateTime _selectedDate = DateTime.now();
  int? _selectedMoodFilter;
  bool _isLoading = false;
  String _searchQuery = '';

  List<Task> get tasks => _filteredTasks;
  List<Task> get allTasks => _tasks;
  DateTime get selectedDate => _selectedDate;
  int? get selectedMoodFilter => _selectedMoodFilter;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  Future<void> loadTasks() async {
    _isLoading = true;

    // Delay notification to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      _tasks = await _databaseHelper.getAllTasks();
      _applyFilters();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading tasks: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTasksByDate(DateTime date) async {
    _isLoading = true;
    _selectedDate = date;

    // Delay notification to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      _tasks = await _databaseHelper.getTasksByDate(date);
      _applyFilters();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading tasks by date: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    loadTasksByDate(date);
  }

  void setMoodFilter(int? moodId) {
    _selectedMoodFilter = moodId;
    _applyFilters();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredTasks = List.from(_tasks);

    // Apply date filter
    _filteredTasks = _filteredTasks.where((task) {
      return task.date.year == _selectedDate.year &&
          task.date.month == _selectedDate.month &&
          task.date.day == _selectedDate.day;
    }).toList();

    // Apply mood filter
    if (_selectedMoodFilter != null) {
      _filteredTasks = _filteredTasks.where((task) {
        return task.moodIds.contains(_selectedMoodFilter);
      }).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      _filteredTasks = _filteredTasks.where((task) {
        return task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (task.description
                    ?.toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ??
                false);
      }).toList();
    }

    // Sort tasks: incomplete first, then completed, with favorites prioritized
    _filteredTasks.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      if (a.isFavorite != b.isFavorite) {
        return b.isFavorite ? 1 : -1;
      }
      return b.createdAt?.compareTo(a.createdAt ?? DateTime.now()) ?? 0;
    });
  }

  Future<Task?> addTask(Task task) async {
    try {
      final id = await _databaseHelper.insertTask(task);
      final newTask = task.copyWith(
        id: id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _tasks.add(newTask);
      _applyFilters();
      notifyListeners();

      return newTask;
    } catch (e) {
      if (kDebugMode) {
        print('Error adding task: $e');
      }
      return null;
    }
  }

  Future<bool> updateTask(Task task) async {
    try {
      final updatedTask = task.copyWith(updatedAt: DateTime.now());
      await _databaseHelper.updateTask(updatedTask);

      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        _applyFilters();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating task: $e');
      }
      return false;
    }
  }

  Future<bool> deleteTask(int taskId) async {
    try {
      await _databaseHelper.deleteTask(taskId);
      _tasks.removeWhere((task) => task.id == taskId);
      _applyFilters();
      notifyListeners();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting task: $e');
      }
      return false;
    }
  }

  Future<bool> toggleTaskCompletion(int taskId) async {
    try {
      await _databaseHelper.toggleTaskCompletion(taskId);

      final index = _tasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        _tasks[index] = _tasks[index].copyWith(
          isCompleted: !_tasks[index].isCompleted,
          updatedAt: DateTime.now(),
        );
        _applyFilters();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling task completion: $e');
      }
      return false;
    }
  }

  Future<bool> toggleTaskFavorite(int taskId) async {
    try {
      await _databaseHelper.toggleTaskFavorite(taskId);

      final index = _tasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        _tasks[index] = _tasks[index].copyWith(
          isFavorite: !_tasks[index].isFavorite,
          updatedAt: DateTime.now(),
        );
        _applyFilters();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling task favorite: $e');
      }
      return false;
    }
  }

  Task? getTaskById(int taskId) {
    try {
      return _tasks.firstWhere((task) => task.id == taskId);
    } catch (e) {
      return null;
    }
  }

  List<Task> getTasksByMood(int moodId) {
    return _tasks.where((task) => task.moodIds.contains(moodId)).toList();
  }

  List<Task> getCompletedTasks() {
    return _tasks.where((task) => task.isCompleted).toList();
  }

  List<Task> getFavoriteTasks() {
    return _tasks.where((task) => task.isFavorite).toList();
  }

  List<Task> getTasksForDateRange(DateTime startDate, DateTime endDate) {
    return _tasks.where((task) {
      return task.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          task.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  void clearFilters() {
    _selectedMoodFilter = null;
    _searchQuery = '';
    _applyFilters();
    notifyListeners();
  }

  int get totalTasks => _tasks.length;
  int get completedTasksCount =>
      _tasks.where((task) => task.isCompleted).length;
  int get pendingTasksCount => _tasks.where((task) => !task.isCompleted).length;
  int get favoriteTasksCount => _tasks.where((task) => task.isFavorite).length;

  double get completionPercentage {
    if (_tasks.isEmpty) return 0.0;
    return completedTasksCount / totalTasks;
  }
}
