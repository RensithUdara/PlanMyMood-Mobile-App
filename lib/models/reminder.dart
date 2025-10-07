enum ReminderType { once, daily, weekly, custom }

class Reminder {
  final int? id;
  final int taskId;
  final ReminderType reminderType;
  final DateTime reminderTime;
  final bool isActive;

  Reminder({
    this.id,
    required this.taskId,
    required this.reminderType,
    required this.reminderTime,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task_id': taskId,
      'reminder_type': reminderType.toString().split('.').last,
      'reminder_time': reminderTime.toIso8601String(),
      'is_active': isActive ? 1 : 0,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      taskId: map['task_id'],
      reminderType: ReminderType.values.firstWhere(
        (e) => e.toString().split('.').last == map['reminder_type'],
      ),
      reminderTime: DateTime.parse(map['reminder_time']),
      isActive: map['is_active'] == 1,
    );
  }

  Reminder copyWith({
    int? id,
    int? taskId,
    ReminderType? reminderType,
    DateTime? reminderTime,
    bool? isActive,
  }) {
    return Reminder(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      reminderType: reminderType ?? this.reminderType,
      reminderTime: reminderTime ?? this.reminderTime,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'Reminder{id: $id, taskId: $taskId, reminderType: $reminderType, reminderTime: $reminderTime, isActive: $isActive}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Reminder &&
        other.id == id &&
        other.taskId == taskId &&
        other.reminderType == reminderType &&
        other.reminderTime == reminderTime &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        taskId.hashCode ^
        reminderType.hashCode ^
        reminderTime.hashCode ^
        isActive.hashCode;
  }
}
