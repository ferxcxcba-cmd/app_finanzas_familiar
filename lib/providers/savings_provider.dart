import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/savings_goal.dart';
import '../services/database_service.dart';
import '../services/sync_service.dart';

class SavingsProvider extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  final SyncService _syncService = SyncService();
  
  List<SavingsGoal> _goals = [];
  String _userId = '';

  List<SavingsGoal> get goals => _goals;
  
  List<SavingsGoal> get activeGoals => _goals.where((g) => !g.isCompleted).toList();
  
  List<SavingsGoal> get completedGoals => _goals.where((g) => g.isCompleted).toList();
  
  double get totalTargeted => _goals.fold(0, (sum, g) => sum + g.targetAmount);
  
  double get totalSaved => _goals.fold(0, (sum, g) => sum + g.currentAmount);
  
  double get overallProgress => totalTargeted > 0 ? (totalSaved / totalTargeted) * 100 : 0;

  SavingsProvider({required String userId}) {
    _userId = userId;
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    try {
      _goals = await _dbService.getSavingsGoals(_userId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading savings goals: $e');
    }
  }

  Future<void> createGoal({
    required String title,
    required String description,
    required double targetAmount,
    required DateTime targetDate,
  }) async {
    try {
      final goal = SavingsGoal(
        id: const Uuid().v4(),
        title: title,
        description: description,
        targetAmount: targetAmount,
        currentAmount: 0,
        createdDate: DateTime.now(),
        targetDate: targetDate,
        userId: _userId,
        isCompleted: false,
      );

      await _dbService.insertSavingsGoal(goal);
      _goals.add(goal);
      
      try {
        await _syncService.syncSavingsGoal(goal);
      } catch (e) {
        debugPrint('Sync error (offline mode): $e');
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error creating savings goal: $e');
      rethrow;
    }
  }

  Future<void> addToGoal(String goalId, double amount) async {
    try {
      final goal = _goals.firstWhere((g) => g.id == goalId);
      final newAmount = goal.currentAmount + amount;
      
      final updatedGoal = SavingsGoal(
        id: goal.id,
        title: goal.title,
        description: goal.description,
        targetAmount: goal.targetAmount,
        currentAmount: newAmount,
        createdDate: goal.createdDate,
        targetDate: goal.targetDate,
        userId: goal.userId,
        isCompleted: newAmount >= goal.targetAmount,
      );

      await _dbService.updateSavingsGoal(updatedGoal);
      final index = _goals.indexWhere((g) => g.id == goalId);
      if (index != -1) {
        _goals[index] = updatedGoal;
      }
      
      try {
        await _syncService.syncSavingsGoal(updatedGoal);
      } catch (e) {
        debugPrint('Sync error (offline mode): $e');
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding to goal: $e');
      rethrow;
    }
  }

  Future<void> deleteGoal(String goalId) async {
    try {
      await _dbService.deleteSavingsGoal(goalId);
      _goals.removeWhere((g) => g.id == goalId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting goal: $e');
      rethrow;
    }
  }

  SavingsGoal? getGoalById(String goalId) {
    try {
      return _goals.firstWhere((g) => g.id == goalId);
    } catch (e) {
      return null;
    }
  }

  Future<void> syncWithRemote() async {
    try {
      final remoteGoals = await _syncService.getRemoteSavingsGoals(_userId);
      _goals = remoteGoals;
      notifyListeners();
    } catch (e) {
      debugPrint('Error syncing savings goals: $e');
    }
  }
}
