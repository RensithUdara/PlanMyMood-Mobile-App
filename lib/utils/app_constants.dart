class AppConstants {
  // App Info
  static const String appName = 'PlanMyMood!';
  static const String appTagline = 'Your personal mood-based task planner';
  
  // Onboarding
  static const List<String> onboardingTitles = [
    'Welcome to\nPlanMyMood!',
    'Get ideas that\nfit your mood',
    'Ready to\nbegin?',
    'Time to choose\nyour mood!',
  ];
  
  static const List<String> onboardingSubtitles = [
    'Your personal mood-based task planner',
    'Discover tasks designed for how you feel today',
    'Let\'s start planning your perfect day',
    '',
  ];

  // Default Moods
  static const List<Map<String, String>> defaultMoods = [
    {'name': 'Joyful', 'emoji': '😊', 'color': '#FFE066'},
    {'name': 'Energy', 'emoji': '🔥', 'color': '#FF9C5C'},
    {'name': 'Inspired', 'emoji': '💡', 'color': '#9B8CE8'},
    {'name': 'Sad', 'emoji': '😢', 'color': '#6BB6E8'},
    {'name': 'Angry', 'emoji': '😠', 'color': '#E86B6B'},
    {'name': 'Apathetic', 'emoji': '😐', 'color': '#A67C52'},
    {'name': 'Tired', 'emoji': '😴', 'color': '#9E9E9E'},
    {'name': 'Not sure', 'emoji': '🤔', 'color': '#F5D76E'},
  ];

  // Task Templates
  static const List<Map<String, String>> taskTemplates = [
    {
      'title': 'Learn a new skill',
      'iconType': 'education',
      'iconColor': '#6BB6E8',
    },
    {
      'title': 'Create a shopping list',
      'iconType': 'shopping',
      'iconColor': '#9B8CE8',
    },
    {
      'title': 'Plan monthly expenses',
      'iconType': 'finance',
      'iconColor': '#6BB6E8',
    },
    {
      'title': 'Prepare a healthy snack',
      'iconType': 'food',
      'iconColor': '#7BC47B',
    },
    {
      'title': 'Clean the room/workspace',
      'iconType': 'cleaning',
      'iconColor': '#FF9C5C',
    },
    {
      'title': 'Complete a report',
      'iconType': 'document',
      'iconColor': '#6BB6E8',
    },
    {
      'title': 'Send a message to friend',
      'iconType': 'message',
      'iconColor': '#9B8CE8',
    },
    {
      'title': 'Create a new music playlist',
      'iconType': 'music',
      'iconColor': '#F5D76E',
    },
    {
      'title': 'Watch a movie or series',
      'iconType': 'entertainment',
      'iconColor': '#6BB6E8',
    },
    {
      'title': 'Update software/apps',
      'iconType': 'update',
      'iconColor': '#9E9E9E',
    },
  ];

  // Icon Types
  static const List<String> iconTypes = [
    'education',
    'shopping',
    'finance',
    'food',
    'cleaning',
    'document',
    'message',
    'music',
    'entertainment',
    'update',
    'health',
    'work',
    'exercise',
    'travel',
    'hobby',
  ];

  // Icon Colors
  static const List<String> iconColors = [
    '#9B8CE8', // Purple
    '#F5D76E', // Yellow
    '#6BB6E8', // Cyan
    '#7BC47B', // Green
    '#FF9C5C', // Orange
    '#E86B6B', // Red
    '#A67C52', // Brown
    '#9E9E9E', // Gray
  ];

  // Reminder Types
  static const List<String> reminderTypes = [
    'Once',
    'Daily',
    'Weekly',
    'Custom',
  ];

  // Animation Durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration fadeAnimationDuration = Duration(milliseconds: 300);
  static const Duration slideAnimationDuration = Duration(milliseconds: 250);

  // Database
  static const String databaseName = 'planmymood.db';
  static const int databaseVersion = 1;

  // SharedPreferences Keys
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keySelectedMoodId = 'selected_mood_id';
  static const String keyLastMoodUpdate = 'last_mood_update';
  static const String keyTheme = 'theme';

  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String timeFormat = 'HH:mm';
  static const String displayTimeFormat = 'h:mm a';

  // Validation
  static const int maxTaskTitleLength = 100;
  static const int maxTaskDescriptionLength = 500;
  static const int minTaskTitleLength = 1;

  // UI Constants
  static const double borderRadius = 12.0;
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;
  static const double iconSize = 24.0;
  static const double moodEmojiSize = 32.0;
  static const double fabSize = 56.0;

  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Task Status
  static const String taskStatusPending = 'pending';
  static const String taskStatusCompleted = 'completed';
  static const String taskStatusFavorite = 'favorite';
}