class Task {
  final int? id;
  final String title;
  final String description;
  final DateTime date;
  final String priority;
  final bool isCompleted;

  const Task({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.priority,
    this.isCompleted = false,
  });

  // Convert Task to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'priority': priority,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  // Create Task from Map (database retrieval)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id']?.toInt(),
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      priority: map['priority'] ?? '',
      isCompleted: map['isCompleted'] == 1,
    );
  }

  // Create a copy of Task with updated fields
  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? date,
    String? priority,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, date: $date, priority: $priority, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Task &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.date == date &&
        other.priority == priority &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        date.hashCode ^
        priority.hashCode ^
        isCompleted.hashCode;
  }
}
