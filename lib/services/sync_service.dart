import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction.dart';
import '../models/budget.dart';
import '../models/savings_goal.dart';

class SyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- SINCRONIZACIÓN DE TRANSACCIONES ---
  Future<void> syncTransaction(Transaction transaction) async {
    try {
      await _firestore
          .collection('users')
          .doc(transaction.userId)
          .collection('transactions')
          .doc(transaction.id)
          .set(transaction.toFirestore(), SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Transaction>> getRemoteTransactions(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Transaction.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // --- SINCRONIZACIÓN DE PRESUPUESTOS ---
  Future<void> syncBudget(Budget budget) async {
    try {
      await _firestore
          .collection('users')
          .doc(budget.userId)
          .collection('budgets')
          .doc(budget.id)
          .set(budget.toFirestore(), SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Budget>> getRemoteBudgets(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('budgets')
          .get();

      return snapshot.docs
          .map((doc) => Budget.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // --- SINCRONIZACIÓN DE OBJETIVOS DE AHORRO ---
  Future<void> syncSavingsGoal(SavingsGoal goal) async {
    try {
      await _firestore
          .collection('users')
          .doc(goal.userId)
          .collection('savings_goals')
          .doc(goal.id)
          .set(goal.toFirestore(), SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SavingsGoal>> getRemoteSavingsGoals(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('savings_goals')
          .get();

      return snapshot.docs
          .map((doc) => SavingsGoal.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // --- SINCRONIZACIÓN FAMILIAR ---
  Future<void> addFamilyMember(
      String userId, String familyCode, String memberEmail) async {
    try {
      await _firestore
          .collection('families')
          .doc(familyCode)
          .collection('members')
          .doc(memberEmail)
          .set({
        'email': memberEmail,
        'joinedDate': DateTime.now(),
        'role': 'member',
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getFamilyMembers(String familyCode) async {
    try {
      final snapshot = await _firestore
          .collection('families')
          .doc(familyCode)
          .collection('members')
          .get();

      return snapshot.docs.map((doc) => doc['email'] as String).toList();
    } catch (e) {
      rethrow;
    }
  }

  // --- STREAMING PARA ACTUALIZACIONES EN TIEMPO REAL ---
  Stream<List<Transaction>> transactionStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Transaction.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  Stream<List<Budget>> budgetStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Budget.fromFirestore(doc.data(), doc.id))
            .toList());
  }
}
