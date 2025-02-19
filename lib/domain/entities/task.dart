class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final String priority;
  final bool isCompleted;
  final String userId;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    this.isCompleted = false,
    required this.userId,
    required this.createdAt,
  });
}
