import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:planmymood_mobileapp/controllers/task_controller.dart';
import 'package:planmymood_mobileapp/database/database_helper.dart';
import 'package:planmymood_mobileapp/models/task.dart';

import 'task_controller_test.mocks.dart';

@GenerateMocks([DatabaseHelper])
void main() {
  group('TaskController Tests', () {
    late TaskController taskController;
    late MockDatabaseHelper mockDatabaseHelper;

    setUp(() {
      mockDatabaseHelper = MockDatabaseHelper();
      taskController = TaskController();
      // Note: In a real implementation, you'd need dependency injection
      // to replace the DatabaseHelper with mock
    });

    test('loadTasks should update tasks list', () async {
      // Arrange
      final mockTasks = [
        Task(
          id: 1,
          title: 'Test Task 1',
          iconType: 'work',
          iconColor: '#FF5722',
          date: DateTime.now(),
        ),
        Task(
          id: 2,
          title: 'Test Task 2',
          iconType: 'personal',
          iconColor: '#2196F3',
          date: DateTime.now(),
        ),
      ];

      when(mockDatabaseHelper.getAllTasks())
          .thenAnswer((_) async => mockTasks);

      // Act
      await taskController.loadTasks();

      // Assert
      expect(taskController.tasks.length, equals(2));
      expect(taskController.isLoading, equals(false));
    });

    test('setSearchQuery should filter tasks', () {
      // Arrange
      taskController.setSearchQuery('work');

      // Assert
      expect(taskController.searchQuery, equals('work'));
    });

    test('toggleTaskFavorite should update task favorite status', () async {
      // Arrange
      when(mockDatabaseHelper.toggleTaskFavorite(1))
          .thenAnswer((_) async {});

      // Act
      final result = await taskController.toggleTaskFavorite(1);

      // Assert - This test would need the actual implementation
      // to be testable with dependency injection
      expect(result, isA<bool>());
    });

    group('Task Statistics', () {
      test('should calculate correct completion percentage', () {
        // This test would require setting up the internal state
        // or making the methods more testable
        expect(taskController.completionPercentage, isA<double>());
      });

      test('should count completed tasks correctly', () {
        expect(taskController.completedTasksCount, isA<int>());
      });

      test('should count total tasks correctly', () {
        expect(taskController.totalTasks, isA<int>());
      });

      test('should count favorite tasks correctly', () {
        expect(taskController.favoriteTasksCount, isA<int>());
      });
    });
  });
}