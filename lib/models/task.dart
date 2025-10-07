class Task {
  final int? id;
  final String title;
  final String? description;
  final String iconType;
  final String iconColor;
  final bool isCompleted;
  final bool isFavorite;
  final DateTime date;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<int> moodIds;

  Task({
    this.id,
    required this.title,
    this.description,
    required this.iconType,
    required this.iconColor,
    this.isCompleted = false,
    this.isFavorite = false,
    required this.date,
    this.createdAt,
    this.updatedAt,
    this.moodIds = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon_type': iconType,
      'icon_color': iconColor,
      'is_completed': isCompleted ? 1 : 0,
      'is_favorite': isFavorite ? 1 : 0,
      'date': date.toIso8601String().split('T')[0], // Store as date only
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      iconType: map['icon_type'],
      iconColor: map['icon_color'],
      isCompleted: map['is_completed'] == 1,
      isFavorite: map['is_favorite'] == 1,
      date: DateTime.parse(map['date']),
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : null,
      updatedAt: map['updated_at'] != null 
          ? DateTime.parse(map['updated_at']) 
          : null,
      moodIds: [], // Will be loaded separately from task_moods table
    );
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? iconType,
    String? iconColor,
    bool? isCompleted,
    bool? isFavorite,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<int>? moodIds,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconType: iconType ?? this.iconType,
      iconColor: iconColor ?? this.iconColor,
      isCompleted: isCompleted ?? this.isCompleted,
      isFavorite: isFavorite ?? this.isFavorite,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      moodIds: moodIds ?? this.moodIds,
    );
  }

  @override
  String toString() {
    return 'Task{id: $id, title: $title, isCompleted: $isCompleted, isFavorite: $isFavorite, date: $date, moodIds: $moodIds}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.iconType == iconType &&
        other.iconColor == iconColor &&
        other.isCompleted == isCompleted &&
        other.isFavorite == isFavorite &&
        other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        iconType.hashCode ^
        iconColor.hashCode ^
        isCompleted.hashCode ^
        isFavorite.hashCode ^
        date.hashCode;
  }
}