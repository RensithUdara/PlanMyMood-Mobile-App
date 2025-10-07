class TaskMood {
  final int? id;
  final int taskId;
  final int moodId;

  TaskMood({
    this.id,
    required this.taskId,
    required this.moodId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task_id': taskId,
      'mood_id': moodId,
    };
  }

  factory TaskMood.fromMap(Map<String, dynamic> map) {
    return TaskMood(
      id: map['id'],
      taskId: map['task_id'],
      moodId: map['mood_id'],
    );
  }

  @override
  String toString() {
    return 'TaskMood{id: $id, taskId: $taskId, moodId: $moodId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskMood &&
        other.id == id &&
        other.taskId == taskId &&
        other.moodId == moodId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ taskId.hashCode ^ moodId.hashCode;
  }
}