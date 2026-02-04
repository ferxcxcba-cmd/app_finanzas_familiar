import 'package:intl/intl.dart';

enum TransactionType { income, expense }

class Transaction {
  final String id;
  final String description;
  final double amount;
  final TransactionType type;
  final String category;
  final DateTime date;
  final String userId;
  final String? notes;
  final bool isRecurring;

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    required this.userId,
    this.notes,
    this.isRecurring = false,
  });

  String get formattedAmount => '\$${amount.toStringAsFixed(2)}';
  
  String get formattedDate => DateFormat('dd/MM/yyyy').format(date);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'type': type.toString(),
      'category': category,
      'date': date.toIso8601String(),
      'userId': userId,
      'notes': notes,
      'isRecurring': isRecurring ? 1 : 0,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      description: map['description'],
      amount: map['amount'],
      type: map['type'].toString().contains('income')
          ? TransactionType.income
          : TransactionType.expense,
      category: map['category'],
      date: DateTime.parse(map['date']),
      userId: map['userId'],
      notes: map['notes'],
      isRecurring: map['isRecurring'] == 1,
    );
  }

  factory Transaction.fromFirestore(Map<String, dynamic> data, String docId) {
    return Transaction(
      id: docId,
      description: data['description'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      type: data['type'] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      category: data['category'] ?? 'Otros',
      date: (data['date'] as dynamic).toDate(),
      userId: data['userId'] ?? '',
      notes: data['notes'],
      isRecurring: data['isRecurring'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'description': description,
      'amount': amount,
      'type': type == TransactionType.income ? 'income' : 'expense',
      'category': category,
      'date': date,
      'userId': userId,
      'notes': notes,
      'isRecurring': isRecurring,
    };
  }
}
