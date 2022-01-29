class TodoItem {
  final int? id;
  final String content;
  // SQLite doesn't supprot DateTime. Store them as INTEGER (millisSinceEpoch).
  final DateTime createdAt;

  TodoItem({
    this.id,
    required this.content,
    required this.createdAt,
  });

  TodoItem.fromJsonMap(Map<String, dynamic> map)
      : id = map['id'] as int,
        content = map['content'] as String,
        createdAt =
        DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int);

  Map<String, dynamic> toJsonMap() => {
    'id': id,
    'content': content,
    'createdAt': createdAt.millisecondsSinceEpoch,
  };
}