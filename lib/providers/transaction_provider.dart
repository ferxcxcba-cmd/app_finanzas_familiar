import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';
import '../services/database_service.dart';
import '../services/sync_service.dart';

class TransactionProvider extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  final SyncService _syncService = SyncService();
  
  List<Transaction> _transactions = [];
  String _userId = '';

  List<Transaction> get transactions => _transactions;
  
  double get totalIncome => _transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0, (sum, t) => sum + t.amount);
  
  double get totalExpense => _transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0, (sum, t) => sum + t.amount);
  
  double get balance => totalIncome - totalExpense;

  TransactionProvider({required String userId}) {
    _userId = userId;
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      _transactions = await _dbService.getTransactions(_userId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading transactions: $e');
    }
  }

  Future<void> addTransaction({
    required String description,
    required double amount,
    required TransactionType type,
    required String category,
    required DateTime date,
    String? notes,
    bool isRecurring = false,
  }) async {
    try {
      final transaction = Transaction(
        id: const Uuid().v4(),
        description: description,
        amount: amount,
        type: type,
        category: category,
        date: date,
        userId: _userId,
        notes: notes,
        isRecurring: isRecurring,
      );

      await _dbService.insertTransaction(transaction);
      _transactions.add(transaction);
      
      // Sincronizar con Firebase si es posible
      try {
        await _syncService.syncTransaction(transaction);
      } catch (e) {
        debugPrint('Sync error (offline mode): $e');
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding transaction: $e');
      rethrow;
    }
  }

  Future<void> updateTransaction(Transaction transaction) async {
    try {
      await _dbService.updateTransaction(transaction);
      final index = _transactions.indexWhere((t) => t.id == transaction.id);
      if (index != -1) {
        _transactions[index] = transaction;
      }
      
      try {
        await _syncService.syncTransaction(transaction);
      } catch (e) {
        debugPrint('Sync error (offline mode): $e');
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating transaction: $e');
      rethrow;
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _dbService.deleteTransaction(id);
      _transactions.removeWhere((t) => t.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
      rethrow;
    }
  }

  List<Transaction> getTransactionsByCategory(String category) {
    return _transactions.where((t) => t.category == category).toList();
  }

  List<Transaction> getTransactionsByMonth(int month, int year) {
    return _transactions
        .where((t) => t.date.month == month && t.date.year == year)
        .toList();
  }

  Map<String, double> getExpensesByCategory() {
    final expenses = _transactions
        .where((t) => t.type == TransactionType.expense)
        .toList();
    
    Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }
    return categoryTotals;
  }

  Future<void> syncWithRemote() async {
    try {
      final remoteTransactions = await _syncService.getRemoteTransactions(_userId);
      _transactions = remoteTransactions;
      notifyListeners();
    } catch (e) {
      debugPrint('Error syncing transactions: $e');
    }
  }
}
