import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/budget.dart';
import '../services/database_service.dart';
import '../services/sync_service.dart';

class BudgetProvider extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  final SyncService _syncService = SyncService();
  
  List<Budget> _budgets = [];
  String _userId = '';
  int _currentMonth = 0;
  int _currentYear = 0;

  List<Budget> get budgets => _budgets;
  
  Budget? getBudgetForCategory(String category) {
    try {
      return _budgets.firstWhere((b) => b.category == category);
    } catch (e) {
      return null;
    }
  }

  BudgetProvider({required String userId}) {
    _userId = userId;
    final now = DateTime.now();
    _currentMonth = now.month;
    _currentYear = now.year;
    _loadBudgets();
  }

  Future<void> _loadBudgets() async {
    try {
      _budgets = await _dbService.getBudgets(_userId, _currentMonth, _currentYear);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading budgets: $e');
    }
  }

  Future<void> createBudget({
    required String category,
    required double limit,
  }) async {
    try {
      final budget = Budget(
        id: const Uuid().v4(),
        category: category,
        limit: limit,
        spent: 0,
        month: _currentMonth,
        year: _currentYear,
        userId: _userId,
      );

      await _dbService.insertBudget(budget);
      _budgets.add(budget);
      
      try {
        await _syncService.syncBudget(budget);
      } catch (e) {
        debugPrint('Sync error (offline mode): $e');
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error creating budget: $e');
      rethrow;
    }
  }

  Future<void> updateBudgetSpent(String budgetId, double newSpent) async {
    try {
      final budget = _budgets.firstWhere((b) => b.id == budgetId);
      final updatedBudget = Budget(
        id: budget.id,
        category: budget.category,
        limit: budget.limit,
        spent: newSpent,
        month: budget.month,
        year: budget.year,
        userId: budget.userId,
      );

      await _dbService.updateBudget(updatedBudget);
      final index = _budgets.indexWhere((b) => b.id == budgetId);
      if (index != -1) {
        _budgets[index] = updatedBudget;
      }
      
      try {
        await _syncService.syncBudget(updatedBudget);
      } catch (e) {
        debugPrint('Sync error (offline mode): $e');
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating budget: $e');
      rethrow;
    }
  }

  Future<void> deleteBudget(String budgetId) async {
    try {
      await _dbService.deleteBudget(budgetId);
      _budgets.removeWhere((b) => b.id == budgetId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting budget: $e');
      rethrow;
    }
  }

  Future<void> changeMonth(int month, int year) async {
    _currentMonth = month;
    _currentYear = year;
    await _loadBudgets();
  }

  List<Budget> getBudgetsExceeded() {
    return _budgets.where((b) => b.isExceeded).toList();
  }

  double getTotalBudgeted() {
    return _budgets.fold(0, (sum, b) => sum + b.limit);
  }

  double getTotalSpent() {
    return _budgets.fold(0, (sum, b) => sum + b.spent);
  }

  Future<void> syncWithRemote() async {
    try {
      final remoteBudgets = await _syncService.getRemoteBudgets(_userId);
      _budgets = remoteBudgets
          .where((b) => b.month == _currentMonth && b.year == _currentYear)
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error syncing budgets: $e');
    }
  }
}
