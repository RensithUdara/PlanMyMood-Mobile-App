class Mood {
  final int? id;
  final String name;
  final String emoji;
  final String color;
  final DateTime? createdAt;

  Mood({
    this.id,
    required this.name,
    required this.emoji,
    required this.color,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
      'color': color,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory Mood.fromMap(Map<String, dynamic> map) {
    return Mood(
      id: map['id'],
      name: map['name'],
      emoji: map['emoji'],
      color: map['color'],
      createdAt:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }

  Mood copyWith({
    int? id,
    String? name,
    String? emoji,
    String? color,
    DateTime? createdAt,
  }) {
    return Mood(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Mood{id: $id, name: $name, emoji: $emoji, color: $color, createdAt: $createdAt}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Mood &&
        other.id == id &&
        other.name == name &&
        other.emoji == emoji &&
        other.color == color;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ emoji.hashCode ^ color.hashCode;
  }
}
