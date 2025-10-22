import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../database/database_helper.dart';
import '../models/mood.dart';
import '../models/task.dart';

class DataExportService {
  static final DataExportService _instance = DataExportService._internal();
  factory DataExportService() => _instance;
  DataExportService._internal();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status == PermissionStatus.granted;
    }
    return true; // iOS doesn't need explicit storage permission for file picking
  }

  Future<String> exportDataAsJson() async {
    try {
      final tasks = await _databaseHelper.getAllTasks();
      final moods = await _databaseHelper.getAllMoods();

      final exportData = {
        'version': '1.0',
        'export_date': DateTime.now().toIso8601String(),
        'tasks': tasks.map((task) => task.toMap()).toList(),
        'moods': moods.map((mood) => mood.toMap()).toList(),
      };

      return json.encode(exportData);
    } catch (e) {
      if (kDebugMode) {
        print('Error exporting data as JSON: $e');
      }
      rethrow;
    }
  }

  Future<String> exportTasksAsCsv() async {
    try {
      final tasks = await _databaseHelper.getAllTasks();

      List<List<dynamic>> csvData = [
        [
          'Title',
          'Description',
          'Date',
          'Completed',
          'Favorite',
          'Icon Type',
          'Icon Color',
          'Created At'
        ]
      ];

      for (final task in tasks) {
        csvData.add([
          task.title,
          task.description ?? '',
          task.date.toIso8601String().split('T')[0],
          task.isCompleted ? 'Yes' : 'No',
          task.isFavorite ? 'Yes' : 'No',
          task.iconType,
          task.iconColor,
          task.createdAt?.toIso8601String().split('T')[0] ?? '',
        ]);
      }

      return const ListToCsvConverter().convert(csvData);
    } catch (e) {
      if (kDebugMode) {
        print('Error exporting tasks as CSV: $e');
      }
      rethrow;
    }
  }

  Future<File> saveDataToFile(String data, String filename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsString(data);
      return file;
    } catch (e) {
      if (kDebugMode) {
        print('Error saving data to file: $e');
      }
      rethrow;
    }
  }

  Future<bool> shareData(String data, String filename, String mimeType) async {
    try {
      final file = await saveDataToFile(data, filename);
      final result = await Share.shareXFiles(
        [XFile(file.path, mimeType: mimeType)],
        text: 'PlanMyMood Data Export',
      );

      return result.status == ShareResultStatus.success;
    } catch (e) {
      if (kDebugMode) {
        print('Error sharing data: $e');
      }
      return false;
    }
  }

  Future<bool> exportAndShareJson() async {
    try {
      final jsonData = await exportDataAsJson();
      final filename =
          'planmymood_backup_${DateTime.now().millisecondsSinceEpoch}.json';
      return await shareData(jsonData, filename, 'application/json');
    } catch (e) {
      if (kDebugMode) {
        print('Error exporting and sharing JSON: $e');
      }
      return false;
    }
  }

  Future<bool> exportAndShareCsv() async {
    try {
      final csvData = await exportTasksAsCsv();
      final filename =
          'planmymood_tasks_${DateTime.now().millisecondsSinceEpoch}.csv';
      return await shareData(csvData, filename, 'text/csv');
    } catch (e) {
      if (kDebugMode) {
        print('Error exporting and sharing CSV: $e');
      }
      return false;
    }
  }

  Future<Map<String, dynamic>?> importDataFromJson() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final contents = await file.readAsString();
        final data = json.decode(contents) as Map<String, dynamic>;

        // Validate data structure
        if (!_isValidImportData(data)) {
          throw Exception('Invalid data format');
        }

        return data;
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error importing data from JSON: $e');
      }
      rethrow;
    }
  }

  Future<bool> importAndRestoreData(Map<String, dynamic> importData) async {
    try {
      // Clear existing data (with user confirmation in UI)
      // This is a destructive operation, should be handled carefully

      // Import tasks
      if (importData['tasks'] != null) {
        final tasksData = importData['tasks'] as List;
        for (final taskData in tasksData) {
          try {
            final task = Task.fromMap(taskData);
            await _databaseHelper.insertTask(task);
          } catch (e) {
            if (kDebugMode) {
              print('Error importing task: $e');
            }
            // Continue with other tasks
          }
        }
      }

      // Import moods (if they don't exist)
      if (importData['moods'] != null) {
        final moodsData = importData['moods'] as List;
        final existingMoods = await _databaseHelper.getAllMoods();
        final existingMoodNames = existingMoods.map((m) => m.name).toSet();

        for (final moodData in moodsData) {
          try {
            final mood = Mood.fromMap(moodData);
            if (!existingMoodNames.contains(mood.name)) {
              await _databaseHelper.insertMood(mood);
            }
          } catch (e) {
            if (kDebugMode) {
              print('Error importing mood: $e');
            }
            // Continue with other moods
          }
        }
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error restoring imported data: $e');
      }
      return false;
    }
  }

  bool _isValidImportData(Map<String, dynamic> data) {
    return data.containsKey('version') &&
        data.containsKey('export_date') &&
        (data.containsKey('tasks') || data.containsKey('moods'));
  }

  Future<Map<String, dynamic>> getDataStatistics() async {
    try {
      final tasks = await _databaseHelper.getAllTasks();
      final moods = await _databaseHelper.getAllMoods();

      final completedTasks = tasks.where((t) => t.isCompleted).length;
      final favoriteTasks = tasks.where((t) => t.isFavorite).length;

      final now = DateTime.now();
      final thisMonth = DateTime(now.year, now.month);
      final tasksThisMonth =
          tasks.where((t) => t.createdAt?.isAfter(thisMonth) ?? false).length;

      return {
        'total_tasks': tasks.length,
        'completed_tasks': completedTasks,
        'favorite_tasks': favoriteTasks,
        'tasks_this_month': tasksThisMonth,
        'total_moods': moods.length,
        'completion_rate': tasks.isNotEmpty
            ? (completedTasks / tasks.length * 100).round()
            : 0,
        'data_size_kb': (await exportDataAsJson()).length ~/ 1024,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error getting data statistics: $e');
      }
      return {};
    }
  }
}
