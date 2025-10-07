import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/mood.dart';
import '../models/reminder.dart';
import '../models/task.dart';
import '../models/user_preferences.dart';
import '../utils/app_constants.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create moods table
    await db.execute('''
      CREATE TABLE moods (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        emoji TEXT NOT NULL,
        color TEXT NOT NULL,
        created_at TEXT
      )
    ''');

    // Create tasks table
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        icon_type TEXT NOT NULL,
        icon_color TEXT NOT NULL,
        is_completed INTEGER NOT NULL DEFAULT 0,
        is_favorite INTEGER NOT NULL DEFAULT 0,
        date TEXT NOT NULL,
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    // Create task_moods table (many-to-many relationship)
    await db.execute('''
      CREATE TABLE task_moods (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        task_id INTEGER NOT NULL,
        mood_id INTEGER NOT NULL,
        FOREIGN KEY (task_id) REFERENCES tasks (id) ON DELETE CASCADE,
        FOREIGN KEY (mood_id) REFERENCES moods (id) ON DELETE CASCADE
      )
    ''');

    // Create reminders table
    await db.execute('''
      CREATE TABLE reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        task_id INTEGER NOT NULL,
        reminder_type TEXT NOT NULL,
        reminder_time TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (task_id) REFERENCES tasks (id) ON DELETE CASCADE
      )
    ''');

    // Create user_preferences table
    await db.execute('''
      CREATE TABLE user_preferences (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        onboarding_completed INTEGER NOT NULL DEFAULT 0,
        selected_mood_id INTEGER,
        last_mood_update TEXT,
        theme TEXT NOT NULL DEFAULT 'light',
        FOREIGN KEY (selected_mood_id) REFERENCES moods (id)
      )
    ''');

    // Insert default moods
    await _insertDefaultMoods(db);

    // Insert default user preferences
    await _insertDefaultUserPreferences(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here if needed
  }

  Future<void> _insertDefaultMoods(Database db) async {
    for (var moodData in AppConstants.defaultMoods) {
      await db.insert('moods', {
        'name': moodData['name'],
        'emoji': moodData['emoji'],
        'color': moodData['color'],
        'created_at': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> _insertDefaultUserPreferences(Database db) async {
    await db.insert('user_preferences', {
      'onboarding_completed': 0,
      'theme': 'light',
    });
  }

  // MOOD CRUD Operations
  Future<List<Mood>> getAllMoods() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('moods');
    return List.generate(maps.length, (i) => Mood.fromMap(maps[i]));
  }

  Future<Mood?> getMoodById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'moods',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Mood.fromMap(maps.first);
    }
    return null;
  }

  Future<int> insertMood(Mood mood) async {
    final db = await database;
    return await db.insert('moods', mood.toMap());
  }

  Future<int> updateMood(Mood mood) async {
    final db = await database;
    return await db.update(
      'moods',
      mood.toMap(),
      where: 'id = ?',
      whereArgs: [mood.id],
    );
  }

  Future<int> deleteMood(int id) async {
    final db = await database;
    return await db.delete(
      'moods',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // TASK CRUD Operations
  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      orderBy: 'created_at DESC',
    );

    List<Task> tasks = [];
    for (var map in maps) {
      Task task = Task.fromMap(map);
      // Load associated mood IDs
      List<int> moodIds = await getTaskMoodIds(task.id!);
      tasks.add(task.copyWith(moodIds: moodIds));
    }
    return tasks;
  }

  Future<List<Task>> getTasksByDate(DateTime date) async {
    final db = await database;
    String dateString = date.toIso8601String().split('T')[0];
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'date = ?',
      whereArgs: [dateString],
      orderBy: 'created_at DESC',
    );

    List<Task> tasks = [];
    for (var map in maps) {
      Task task = Task.fromMap(map);
      List<int> moodIds = await getTaskMoodIds(task.id!);
      tasks.add(task.copyWith(moodIds: moodIds));
    }
    return tasks;
  }

  Future<List<Task>> getTasksByMood(int moodId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT t.* FROM tasks t
      INNER JOIN task_moods tm ON t.id = tm.task_id
      WHERE tm.mood_id = ?
      ORDER BY t.created_at DESC
    ''', [moodId]);

    List<Task> tasks = [];
    for (var map in maps) {
      Task task = Task.fromMap(map);
      List<int> moodIds = await getTaskMoodIds(task.id!);
      tasks.add(task.copyWith(moodIds: moodIds));
    }
    return tasks;
  }

  Future<Task?> getTaskById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      Task task = Task.fromMap(maps.first);
      List<int> moodIds = await getTaskMoodIds(id);
      return task.copyWith(moodIds: moodIds);
    }
    return null;
  }

  Future<int> insertTask(Task task) async {
    final db = await database;

    // Start a transaction to ensure data consistency
    return await db.transaction((txn) async {
      // Insert the task
      int taskId = await txn.insert('tasks', task.toMap());

      // Insert task-mood relationships
      for (int moodId in task.moodIds) {
        await txn.insert('task_moods', {
          'task_id': taskId,
          'mood_id': moodId,
        });
      }

      return taskId;
    });
  }

  Future<int> updateTask(Task task) async {
    final db = await database;

    return await db.transaction((txn) async {
      // Update the task
      int result = await txn.update(
        'tasks',
        task.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );

      // Delete existing task-mood relationships
      await txn.delete(
        'task_moods',
        where: 'task_id = ?',
        whereArgs: [task.id],
      );

      // Insert new task-mood relationships
      for (int moodId in task.moodIds) {
        await txn.insert('task_moods', {
          'task_id': task.id,
          'mood_id': moodId,
        });
      }

      return result;
    });
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> toggleTaskCompletion(int taskId) async {
    final db = await database;
    Task? task = await getTaskById(taskId);
    if (task != null) {
      return await db.update(
        'tasks',
        {
          'is_completed': task.isCompleted ? 0 : 1,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [taskId],
      );
    }
    return 0;
  }

  Future<int> toggleTaskFavorite(int taskId) async {
    final db = await database;
    Task? task = await getTaskById(taskId);
    if (task != null) {
      return await db.update(
        'tasks',
        {
          'is_favorite': task.isFavorite ? 0 : 1,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [taskId],
      );
    }
    return 0;
  }

  // TASK_MOODS Operations
  Future<List<int>> getTaskMoodIds(int taskId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'task_moods',
      where: 'task_id = ?',
      whereArgs: [taskId],
    );
    return maps.map((map) => map['mood_id'] as int).toList();
  }

  Future<List<Mood>> getTaskMoods(int taskId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT m.* FROM moods m
      INNER JOIN task_moods tm ON m.id = tm.mood_id
      WHERE tm.task_id = ?
    ''', [taskId]);
    return List.generate(maps.length, (i) => Mood.fromMap(maps[i]));
  }

  // REMINDER CRUD Operations
  Future<List<Reminder>> getAllReminders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('reminders');
    return List.generate(maps.length, (i) => Reminder.fromMap(maps[i]));
  }

  Future<List<Reminder>> getRemindersByTask(int taskId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'reminders',
      where: 'task_id = ?',
      whereArgs: [taskId],
    );
    return List.generate(maps.length, (i) => Reminder.fromMap(maps[i]));
  }

  Future<int> insertReminder(Reminder reminder) async {
    final db = await database;
    return await db.insert('reminders', reminder.toMap());
  }

  Future<int> updateReminder(Reminder reminder) async {
    final db = await database;
    return await db.update(
      'reminders',
      reminder.toMap(),
      where: 'id = ?',
      whereArgs: [reminder.id],
    );
  }

  Future<int> deleteReminder(int id) async {
    final db = await database;
    return await db.delete(
      'reminders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteRemindersByTask(int taskId) async {
    final db = await database;
    return await db.delete(
      'reminders',
      where: 'task_id = ?',
      whereArgs: [taskId],
    );
  }

  // USER_PREFERENCES Operations
  Future<UserPreferences> getUserPreferences() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user_preferences');
    if (maps.isNotEmpty) {
      return UserPreferences.fromMap(maps.first);
    }
    // Return default preferences if none exist
    return UserPreferences();
  }

  Future<int> updateUserPreferences(UserPreferences preferences) async {
    final db = await database;

    // Check if preferences exist
    final existing = await db.query('user_preferences');

    if (existing.isEmpty) {
      return await db.insert('user_preferences', preferences.toMap());
    } else {
      return await db.update(
        'user_preferences',
        preferences.toMap(),
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
    }
  }

  Future<bool> isOnboardingCompleted() async {
    final preferences = await getUserPreferences();
    return preferences.onboardingCompleted;
  }

  Future<void> completeOnboarding() async {
    final preferences = await getUserPreferences();
    await updateUserPreferences(
      preferences.copyWith(onboardingCompleted: true),
    );
  }

  Future<void> setSelectedMood(int moodId) async {
    final preferences = await getUserPreferences();
    await updateUserPreferences(
      preferences.copyWith(
        selectedMoodId: moodId,
        lastMoodUpdate: DateTime.now(),
      ),
    );
  }

  // Database utility methods
  Future<void> clearAllData() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('task_moods');
      await txn.delete('reminders');
      await txn.delete('tasks');
      await txn.delete('user_preferences');
      await txn.delete('moods');
    });

    // Re-insert default data
    await _insertDefaultMoods(db);
    await _insertDefaultUserPreferences(db);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
