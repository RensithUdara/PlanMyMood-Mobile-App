import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  static const String _sessionKey = 'analytics_session_id';
  static const String _userIdKey = 'analytics_user_id';
  static const String _eventsKey = 'analytics_events';

  String? _sessionId;
  String? _userId;
  final List<AnalyticsEvent> _events = [];
  final Uuid _uuid = const Uuid();

  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get or create user ID
      _userId = prefs.getString(_userIdKey);
      if (_userId == null) {
        _userId = _uuid.v4();
        await prefs.setString(_userIdKey, _userId!);
      }

      // Create new session
      _sessionId = _uuid.v4();
      await prefs.setString(_sessionKey, _sessionId!);

      // Load pending events
      await _loadPendingEvents();

      // Track session start
      await trackEvent('session_start', {
        'session_id': _sessionId,
        'user_id': _userId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (kDebugMode) {
        print('Analytics initialized with session: $_sessionId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to initialize analytics: $e');
      }
    }
  }

  Future<void> trackEvent(String eventName,
      [Map<String, dynamic>? properties]) async {
    try {
      final event = AnalyticsEvent(
        name: eventName,
        properties: {
          'session_id': _sessionId,
          'user_id': _userId,
          'timestamp': DateTime.now().toIso8601String(),
          ...?properties,
        },
        timestamp: DateTime.now(),
      );

      _events.add(event);

      // Save events locally
      await _saveEvents();

      if (kDebugMode) {
        print('Analytics: $eventName - ${event.properties}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to track event: $e');
      }
    }
  }

  // Task-related events
  Future<void> trackTaskCreated(String taskTitle, String moodType) async {
    await trackEvent('task_created', {
      'task_title': taskTitle,
      'mood_type': moodType,
    });
  }

  Future<void> trackTaskCompleted(String taskTitle, Duration timeTaken) async {
    await trackEvent('task_completed', {
      'task_title': taskTitle,
      'time_taken_minutes': timeTaken.inMinutes,
    });
  }

  Future<void> trackMoodSelected(String moodName) async {
    await trackEvent('mood_selected', {
      'mood_name': moodName,
    });
  }

  Future<void> trackScreenView(String screenName) async {
    await trackEvent('screen_view', {
      'screen_name': screenName,
    });
  }

  Future<void> trackUserAction(String action,
      [Map<String, dynamic>? data]) async {
    await trackEvent('user_action', {
      'action': action,
      ...?data,
    });
  }

  Future<void> _loadPendingEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final eventsJson = prefs.getString(_eventsKey);
      if (eventsJson != null) {
        final eventsList = json.decode(eventsJson) as List;
        _events.clear();
        _events.addAll(
          eventsList.map((e) => AnalyticsEvent.fromJson(e)).toList(),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load pending events: $e');
      }
    }
  }

  Future<void> _saveEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final eventsJson = json.encode(_events.map((e) => e.toJson()).toList());
      await prefs.setString(_eventsKey, eventsJson);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to save events: $e');
      }
    }
  }

  Future<Map<String, dynamic>> getAnalyticsSummary() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final todayEvents = _events
        .where((e) =>
            e.timestamp.isAfter(today) || e.timestamp.isAtSameMomentAs(today))
        .toList();

    return {
      'total_events': _events.length,
      'today_events': todayEvents.length,
      'session_id': _sessionId,
      'user_id': _userId,
      'most_frequent_actions': _getMostFrequentActions(),
      'mood_usage': _getMoodUsageStats(),
    };
  }

  Map<String, int> _getMostFrequentActions() {
    final actionCounts = <String, int>{};
    for (final event in _events) {
      actionCounts[event.name] = (actionCounts[event.name] ?? 0) + 1;
    }

    final sorted = actionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sorted.take(5));
  }

  Map<String, int> _getMoodUsageStats() {
    final moodCounts = <String, int>{};
    for (final event in _events.where((e) => e.name == 'mood_selected')) {
      final moodName = event.properties['mood_name'] as String?;
      if (moodName != null) {
        moodCounts[moodName] = (moodCounts[moodName] ?? 0) + 1;
      }
    }
    return moodCounts;
  }

  Future<void> clearAnalyticsData() async {
    try {
      _events.clear();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_eventsKey);

      if (kDebugMode) {
        print('Analytics data cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to clear analytics data: $e');
      }
    }
  }
}

class AnalyticsEvent {
  final String name;
  final Map<String, dynamic> properties;
  final DateTime timestamp;

  AnalyticsEvent({
    required this.name,
    required this.properties,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'properties': properties,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory AnalyticsEvent.fromJson(Map<String, dynamic> json) {
    return AnalyticsEvent(
      name: json['name'],
      properties: json['properties'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
