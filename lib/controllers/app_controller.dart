import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/database_helper.dart';
import '../models/user_preferences.dart';
import '../utils/app_constants.dart';

class AppController extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  UserPreferences _userPreferences = UserPreferences();
  bool _isLoading = false;
  bool _isDarkMode = false;

  UserPreferences get userPreferences => _userPreferences;
  bool get isLoading => _isLoading;
  bool get isDarkMode => _isDarkMode;
  bool get isOnboardingCompleted => _userPreferences.onboardingCompleted;

  Future<void> initialize() async {
    _isLoading = true;

    try {
      await _loadUserPreferences();
      await _loadThemePreference();
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing app: $e');
      }
    } finally {
      _isLoading = false;
    }
  }

  Future<void> _loadUserPreferences() async {
    try {
      _userPreferences = await _databaseHelper.getUserPreferences();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user preferences: $e');
      }
    }
  }

  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool(AppConstants.keyTheme) ?? false;
    } catch (e) {
      if (kDebugMode) {
        print('Error loading theme preference: $e');
      }
    }
  }

  Future<void> completeOnboarding() async {
    try {
      await _databaseHelper.completeOnboarding();
      _userPreferences = _userPreferences.copyWith(onboardingCompleted: true);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error completing onboarding: $e');
      }
    }
  }

  Future<void> setSelectedMood(int moodId) async {
    try {
      await _databaseHelper.setSelectedMood(moodId);
      _userPreferences = _userPreferences.copyWith(
        selectedMoodId: moodId,
        lastMoodUpdate: DateTime.now(),
      );
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error setting selected mood: $e');
      }
    }
  }

  Future<void> toggleTheme() async {
    try {
      _isDarkMode = !_isDarkMode;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keyTheme, _isDarkMode);

      _userPreferences = _userPreferences.copyWith(
        theme: _isDarkMode ? 'dark' : 'light',
      );
      await _databaseHelper.updateUserPreferences(_userPreferences);

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling theme: $e');
      }
    }
  }

  Future<void> updateUserPreferences(UserPreferences preferences) async {
    try {
      await _databaseHelper.updateUserPreferences(preferences);
      _userPreferences = preferences;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user preferences: $e');
      }
    }
  }

  Future<void> resetApp() async {
    try {
      await _databaseHelper.clearAllData();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      _userPreferences = UserPreferences();
      _isDarkMode = false;

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error resetting app: $e');
      }
    }
  }

  bool shouldShowOnboarding() {
    return !_userPreferences.onboardingCompleted;
  }

  bool hasMoodBeenSelectedToday() {
    if (_userPreferences.lastMoodUpdate == null) return false;

    final now = DateTime.now();
    final lastUpdate = _userPreferences.lastMoodUpdate!;

    return now.year == lastUpdate.year &&
        now.month == lastUpdate.month &&
        now.day == lastUpdate.day;
  }

  Future<void> clearMoodSelection() async {
    try {
      _userPreferences = _userPreferences.copyWith(
        selectedMoodId: null,
        lastMoodUpdate: null,
      );
      await _databaseHelper.updateUserPreferences(_userPreferences);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing mood selection: $e');
      }
    }
  }
}
