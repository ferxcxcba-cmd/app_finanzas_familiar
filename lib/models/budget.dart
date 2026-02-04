class Budget {
  final String id;
  final String category;
  final double limit;
  final double spent;
  final int month;
  final int year;
  final String userId;

  Budget({
    required this.id,
    required this.category,
    required this.limit,
    required this.spent,
    required this.month,
    required this.year,
    required this.userId,
  });

  double get remaining => limit - spent;
  
  double get percentage => (spent / limit) * 100;
  
  bool get isExceeded => spent > limit;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'limit': limit,
      'spent': spent,
      'month': month,
      'year': year,
      'userId': userId,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'],
      category: map['category'],
      limit: map['limit'],
      spent: map['spent'],
      month: map['month'],
      year: map['year'],
      userId: map['userId'],
    );
  }

  factory Budget.fromFirestore(Map<String, dynamic> data, String docId) {
    return Budget(
      id: docId,
      category: data['category'] ?? '',
      limit: (data['limit'] ?? 0).toDouble(),
      spent: (data['spent'] ?? 0).toDouble(),
      month: data['month'] ?? 0,
      year: data['year'] ?? 0,
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'category': category,
      'limit': limit,
      'spent': spent,
      'month': month,
      'year': year,
      'userId': userId,
    };
  }
}
