import 'package:flutter_test/flutter_test.dart';
import 'package:planmymood_mobileapp/models/task.dart';
import 'package:planmymood_mobileapp/models/mood.dart';

void main() {
  group('Task Model Tests', () {
    test('Task creation with valid data', () {
      final task = Task(
        id: 1,
        title: 'Test Task',
        description: 'This is a test task',
        iconType: 'work',
        iconColor: '#FF5722',
        date: DateTime.now(),
        isCompleted: false,
        isFavorite: false,
        moodIds: [1, 2],
      );

      expect(task.id, equals(1));
      expect(task.title, equals('Test Task'));
      expect(task.description, equals('This is a test task'));
      expect(task.iconType, equals('work'));
      expect(task.iconColor, equals('#FF5722'));
      expect(task.isCompleted, equals(false));
      expect(task.isFavorite, equals(false));
      expect(task.moodIds, equals([1, 2]));
    });

    test('Task toMap conversion', () {
      final task = Task(
        id: 1,
        title: 'Test Task',
        iconType: 'work',
        iconColor: '#FF5722',
        date: DateTime(2023, 12, 25),
        moodIds: [1],
      );

      final map = task.toMap();

      expect(map['id'], equals(1));
      expect(map['title'], equals('Test Task'));
      expect(map['icon_type'], equals('work'));
      expect(map['icon_color'], equals('#FF5722'));
      expect(map['date'], equals('2023-12-25'));
      expect(map['is_completed'], equals(0));
      expect(map['is_favorite'], equals(0));
    });

    test('Task fromMap conversion', () {
      final map = {
        'id': 1,
        'title': 'Test Task',
        'description': 'Test Description',
        'icon_type': 'work',
        'icon_color': '#FF5722',
        'is_completed': 1,
        'is_favorite': 0,
        'date': '2023-12-25',
        'created_at': '2023-12-25T10:00:00.000Z',
        'updated_at': '2023-12-25T10:30:00.000Z',
      };

      final task = Task.fromMap(map);

      expect(task.id, equals(1));
      expect(task.title, equals('Test Task'));
      expect(task.description, equals('Test Description'));
      expect(task.iconType, equals('work'));
      expect(task.iconColor, equals('#FF5722'));
      expect(task.isCompleted, equals(true));
      expect(task.isFavorite, equals(false));
      expect(task.date, equals(DateTime(2023, 12, 25)));
    });

    test('Task copyWith method', () {
      final originalTask = Task(
        id: 1,
        title: 'Original Task',
        iconType: 'work',
        iconColor: '#FF5722',
        date: DateTime.now(),
      );

      final copiedTask = originalTask.copyWith(
        title: 'Updated Task',
        isCompleted: true,
      );

      expect(copiedTask.id, equals(1));
      expect(copiedTask.title, equals('Updated Task'));
      expect(copiedTask.isCompleted, equals(true));
      expect(copiedTask.iconType, equals('work')); // Unchanged
      expect(copiedTask.iconColor, equals('#FF5722')); // Unchanged
    });
  });

  group('Mood Model Tests', () {
    test('Mood creation with valid data', () {
      final mood = Mood(
        id: 1,
        name: 'Happy',
        emoji: '😊',
        color: '#FFD700',
      );

      expect(mood.id, equals(1));
      expect(mood.name, equals('Happy'));
      expect(mood.emoji, equals('😊'));
      expect(mood.color, equals('#FFD700'));
    });

    test('Mood toMap conversion', () {
      final mood = Mood(
        id: 1,
        name: 'Happy',
        emoji: '😊',
        color: '#FFD700',
      );

      final map = mood.toMap();

      expect(map['id'], equals(1));
      expect(map['name'], equals('Happy'));
      expect(map['emoji'], equals('😊'));
      expect(map['color'], equals('#FFD700'));
    });

    test('Mood fromMap conversion', () {
      final map = {
        'id': 1,
        'name': 'Happy',
        'emoji': '😊',
        'color': '#FFD700',
        'created_at': '2023-12-25T10:00:00.000Z',
      };

      final mood = Mood.fromMap(map);

      expect(mood.id, equals(1));
      expect(mood.name, equals('Happy'));
      expect(mood.emoji, equals('😊'));
      expect(mood.color, equals('#FFD700'));
    });
  });
}