class UserPreferences {
  final int? id;
  final bool onboardingCompleted;
  final int? selectedMoodId;
  final DateTime? lastMoodUpdate;
  final String theme;

  UserPreferences({
    this.id,
    this.onboardingCompleted = false,
    this.selectedMoodId,
    this.lastMoodUpdate,
    this.theme = 'light',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'onboarding_completed': onboardingCompleted ? 1 : 0,
      'selected_mood_id': selectedMoodId,
      'last_mood_update': lastMoodUpdate?.toIso8601String(),
      'theme': theme,
    };
  }

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      id: map['id'],
      onboardingCompleted: map['onboarding_completed'] == 1,
      selectedMoodId: map['selected_mood_id'],
      lastMoodUpdate: map['last_mood_update'] != null
          ? DateTime.parse(map['last_mood_update'])
          : null,
      theme: map['theme'] ?? 'light',
    );
  }

  UserPreferences copyWith({
    int? id,
    bool? onboardingCompleted,
    int? selectedMoodId,
    DateTime? lastMoodUpdate,
    String? theme,
  }) {
    return UserPreferences(
      id: id ?? this.id,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      selectedMoodId: selectedMoodId ?? this.selectedMoodId,
      lastMoodUpdate: lastMoodUpdate ?? this.lastMoodUpdate,
      theme: theme ?? this.theme,
    );
  }

  @override
  String toString() {
    return 'UserPreferences{id: $id, onboardingCompleted: $onboardingCompleted, selectedMoodId: $selectedMoodId, lastMoodUpdate: $lastMoodUpdate, theme: $theme}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserPreferences &&
        other.id == id &&
        other.onboardingCompleted == onboardingCompleted &&
        other.selectedMoodId == selectedMoodId &&
        other.lastMoodUpdate == lastMoodUpdate &&
        other.theme == theme;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        onboardingCompleted.hashCode ^
        selectedMoodId.hashCode ^
        lastMoodUpdate.hashCode ^
        theme.hashCode;
  }
}
