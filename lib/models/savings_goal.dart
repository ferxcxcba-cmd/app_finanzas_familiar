class SavingsGoal {
  final String id;
  final String title;
  final String description;
  final double targetAmount;
  final double currentAmount;
  final DateTime createdDate;
  final DateTime targetDate;
  final String userId;
  final bool isCompleted;

  SavingsGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.targetAmount,
    required this.currentAmount,
    required this.createdDate,
    required this.targetDate,
    required this.userId,
    this.isCompleted = false,
  });

  double get progress => (currentAmount / targetAmount) * 100;
  
  double get remaining => targetAmount - currentAmount;
  
  int get daysRemaining => targetDate.difference(DateTime.now()).inDays;
  
  bool get isOverdue => DateTime.now().isAfter(targetDate) && !isCompleted;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'createdDate': createdDate.toIso8601String(),
      'targetDate': targetDate.toIso8601String(),
      'userId': userId,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory SavingsGoal.fromMap(Map<String, dynamic> map) {
    return SavingsGoal(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      targetAmount: map['targetAmount'],
      currentAmount: map['currentAmount'],
      createdDate: DateTime.parse(map['createdDate']),
      targetDate: DateTime.parse(map['targetDate']),
      userId: map['userId'],
      isCompleted: map['isCompleted'] == 1,
    );
  }

  factory SavingsGoal.fromFirestore(Map<String, dynamic> data, String docId) {
    return SavingsGoal(
      id: docId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      targetAmount: (data['targetAmount'] ?? 0).toDouble(),
      currentAmount: (data['currentAmount'] ?? 0).toDouble(),
      createdDate: (data['createdDate'] as dynamic).toDate(),
      targetDate: (data['targetDate'] as dynamic).toDate(),
      userId: data['userId'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'createdDate': createdDate,
      'targetDate': targetDate,
      'userId': userId,
      'isCompleted': isCompleted,
    };
  }
}
