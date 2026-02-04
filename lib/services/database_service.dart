import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction.dart';
import '../models/budget.dart';
import '../models/savings_goal.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'finanzas_familiar.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Tabla de transacciones
        await db.execute('''
          CREATE TABLE transactions (
            id TEXT PRIMARY KEY,
            description TEXT NOT NULL,
            amount REAL NOT NULL,
            type TEXT NOT NULL,
            category TEXT NOT NULL,
            date TEXT NOT NULL,
            userId TEXT NOT NULL,
            notes TEXT,
            isRecurring INTEGER NOT NULL
          )
        ''');

        // Tabla de presupuestos
        await db.execute('''
          CREATE TABLE budgets (
            id TEXT PRIMARY KEY,
            category TEXT NOT NULL,
            limit REAL NOT NULL,
            spent REAL NOT NULL,
            month INTEGER NOT NULL,
            year INTEGER NOT NULL,
            userId TEXT NOT NULL
          )
        ''');

        // Tabla de objetivos de ahorro
        await db.execute('''
          CREATE TABLE savings_goals (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT,
            targetAmount REAL NOT NULL,
            currentAmount REAL NOT NULL,
            createdDate TEXT NOT NULL,
            targetDate TEXT NOT NULL,
            userId TEXT NOT NULL,
            isCompleted INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  // --- TRANSACCIONES ---
  Future<void> insertTransaction(Transaction transaction) async {
    final db = await database;
    await db.insert('transactions', transaction.toMap());
  }

  Future<List<Transaction>> getTransactions(String userId) async {
    final db = await database;
    final maps = await db.query(
      'transactions',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Transaction.fromMap(maps[i]));
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final db = await database;
    await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<void> deleteTransaction(String id) async {
    final db = await database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  // --- PRESUPUESTOS ---
  Future<void> insertBudget(Budget budget) async {
    final db = await database;
    await db.insert('budgets', budget.toMap());
  }

  Future<List<Budget>> getBudgets(String userId, int month, int year) async {
    final db = await database;
    final maps = await db.query(
      'budgets',
      where: 'userId = ? AND month = ? AND year = ?',
      whereArgs: [userId, month, year],
    );
    return List.generate(maps.length, (i) => Budget.fromMap(maps[i]));
  }

  Future<void> updateBudget(Budget budget) async {
    final db = await database;
    await db.update('budgets', budget.toMap(),
        where: 'id = ?', whereArgs: [budget.id]);
  }

  Future<void> deleteBudget(String id) async {
    final db = await database;
    await db.delete('budgets', where: 'id = ?', whereArgs: [id]);
  }

  // --- OBJETIVOS DE AHORRO ---
  Future<void> insertSavingsGoal(SavingsGoal goal) async {
    final db = await database;
    await db.insert('savings_goals', goal.toMap());
  }

  Future<List<SavingsGoal>> getSavingsGoals(String userId) async {
    final db = await database;
    final maps = await db.query(
      'savings_goals',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'targetDate ASC',
    );
    return List.generate(maps.length, (i) => SavingsGoal.fromMap(maps[i]));
  }

  Future<void> updateSavingsGoal(SavingsGoal goal) async {
    final db = await database;
    await db.update('savings_goals', goal.toMap(),
        where: 'id = ?', whereArgs: [goal.id]);
  }

  Future<void> deleteSavingsGoal(String id) async {
    final db = await database;
    await db.delete('savings_goals', where: 'id = ?', whereArgs: [id]);
  }

  // --- UTILIDADES ---
  Future<void> deleteDatabase() async {
    String path = join(await getDatabasesPath(), 'finanzas_familiar.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
