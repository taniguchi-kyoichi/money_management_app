class ExpenseItem {
  final int? id;
  final int price;
  final String content;

  // SQLite doesn't supprot DateTime. Store them as INTEGER (millisSinceEpoch).
  final DateTime createdAt;

  ExpenseItem({
    this.id,
    required this.price,
    required this.content,
    required this.createdAt,
  });

  ExpenseItem.fromJsonMap(Map<String, dynamic> map)
      : id = map['id'] as int,
        price = map['price'] as int,
        content = map['content'] as String,
        createdAt =
            DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int);

  Map<String, dynamic> toJsonMap() => {
        'id': id,
        'price': price,
        'content': content,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };
}
