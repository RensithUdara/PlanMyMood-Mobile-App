import 'package:flutter/foundation.dart';

import '../database/database_helper.dart';
import '../models/mood.dart';

class MoodController extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<Mood> _moods = [];
  Mood? _selectedMood;
  bool _isLoading = false;

  List<Mood> get moods => _moods;
  Mood? get selectedMood => _selectedMood;
  bool get isLoading => _isLoading;

  Future<void> loadMoods() async {
    _isLoading = true;
    notifyListeners();

    try {
      _moods = await _databaseHelper.getAllMoods();
      await _loadSelectedMood();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading moods: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadSelectedMood() async {
    try {
      final preferences = await _databaseHelper.getUserPreferences();
      if (preferences.selectedMoodId != null) {
        _selectedMood =
            await _databaseHelper.getMoodById(preferences.selectedMoodId!);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading selected mood: $e');
      }
    }
  }

  Future<void> selectMood(Mood mood) async {
    try {
      _selectedMood = mood;
      await _databaseHelper.setSelectedMood(mood.id!);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error selecting mood: $e');
      }
    }
  }

  Future<void> addMood(Mood mood) async {
    try {
      final id = await _databaseHelper.insertMood(mood);
      final newMood = mood.copyWith(id: id);
      _moods.add(newMood);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error adding mood: $e');
      }
    }
  }

  Future<void> updateMood(Mood mood) async {
    try {
      await _databaseHelper.updateMood(mood);
      final index = _moods.indexWhere((m) => m.id == mood.id);
      if (index != -1) {
        _moods[index] = mood;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating mood: $e');
      }
    }
  }

  Future<void> deleteMood(int moodId) async {
    try {
      await _databaseHelper.deleteMood(moodId);
      _moods.removeWhere((mood) => mood.id == moodId);

      // Clear selected mood if it was deleted
      if (_selectedMood?.id == moodId) {
        _selectedMood = null;
      }

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting mood: $e');
      }
    }
  }

  Mood? getMoodById(int moodId) {
    try {
      return _moods.firstWhere((mood) => mood.id == moodId);
    } catch (e) {
      return null;
    }
  }

  List<Mood> getMoodsByIds(List<int> moodIds) {
    return _moods.where((mood) => moodIds.contains(mood.id)).toList();
  }

  void clearSelection() {
    _selectedMood = null;
    notifyListeners();
  }

  bool isMoodSelected(Mood mood) {
    return _selectedMood?.id == mood.id;
  }
}
