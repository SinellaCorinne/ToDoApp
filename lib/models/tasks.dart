class Task {
  final int id;
  final String title;
  final String description;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isDone,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        title: json['title'],
        description: json['description'] ?? '',
        isDone: json['is_done'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'is_done': isDone,
      };
}
