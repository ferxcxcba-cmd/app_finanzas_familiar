import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/budget_provider.dart';
import '../providers/savings_provider.dart';
import '../models/transaction.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_item.dart';
import '../utils/constants.dart';
import 'add_transaction_screen.dart';
import 'analytics_screen.dart';
import 'budgets_screen.dart';
import 'savings_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userId;

  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TransactionProvider(userId: widget.userId),
        ),
        ChangeNotifierProvider(
          create: (_) => BudgetProvider(userId: widget.userId),
        ),
        ChangeNotifierProvider(
          create: (_) => SavingsProvider(userId: widget.userId),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeTab(),
            const AnalyticsScreen(),
            const BudgetsScreen(),
            const SavingsScreen(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const AddTransactionScreen(),
              ),
            );
          },
          backgroundColor: AppColors.primaryColor,
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Análisis',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wallet),
              label: 'Presupuestos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.target),
              label: 'Ahorros',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              
              // Tarjeta de Saldo
              BalanceCard(
                balance: transactionProvider.balance,
                income: transactionProvider.totalIncome,
                expense: transactionProvider.totalExpense,
              ),
              
              const SizedBox(height: AppSpacing.lg),

              // Sección de Transacciones Recientes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transacciones Recientes',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  TextButton(
                    onPressed: () => setState(() => _selectedIndex = 1),
                    child: const Text('Ver todo'),
                  ),
                ],
              ),
              
              const SizedBox(height: AppSpacing.sm),

              if (transactionProvider.transactions.isEmpty)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(
                        Icons.inbox,
                        size: 48,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Sin transacciones aún',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[500],
                            ),
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      transactionProvider.transactions.length > 5
                          ? 5
                          : transactionProvider.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction =
                        transactionProvider.transactions[index];
                    return TransactionItem(
                      transaction: transaction,
                      onDelete: () {
                        transactionProvider.deleteTransaction(transaction.id);
                      },
                    );
                  },
                ),

              const SizedBox(height: AppSpacing.lg),

              // Alertas de Presupuesto
              Consumer<BudgetProvider>(
                builder: (context, budgetProvider, _) {
                  final exceededBudgets = budgetProvider.getBudgetsExceeded();
                  if (exceededBudgets.isNotEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.errorColor.withOpacity(0.1),
                        border: Border.all(color: AppColors.errorColor),
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.warning, color: AppColors.errorColor),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Presupuestos Excedidos',
                                style:
                                    Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: AppColors.errorColor,
                                        ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          ...exceededBudgets.map((budget) => Text(
                                '${budget.category}: \$${budget.spent.toStringAsFixed(2)} / \$${budget.limit.toStringAsFixed(2)}',
                                style:
                                    Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppColors.errorColor,
                                        ),
                              )),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
