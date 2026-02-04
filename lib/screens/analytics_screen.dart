import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Análisis'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Consumer<TransactionProvider>(
          builder: (context, transactionProvider, _) {
            final monthTransactions = transactionProvider.getTransactionsByMonth(
              _selectedMonth,
              _selectedYear,
            );

            final monthlyIncome = monthTransactions
                .where((t) => t.type == TransactionType.income)
                .fold(0.0, (sum, t) => sum + t.amount);

            final monthlyExpense = monthTransactions
                .where((t) => t.type == TransactionType.expense)
                .fold(0.0, (sum, t) => sum + t.amount);

            final expensesByCategory =
                transactionProvider.getExpensesByCategory();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Selector de Mes
                _buildMonthSelector(),
                const SizedBox(height: AppSpacing.lg),

                // Resumen Mensual
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        'Ingresos',
                        monthlyIncome,
                        Colors.green,
                        Icons.arrow_downward,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _buildSummaryCard(
                        'Egresos',
                        monthlyExpense,
                        Colors.red,
                        Icons.arrow_upward,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Gráfico de Pastel - Gastos por Categoría
                if (expensesByCategory.isNotEmpty)
                  _buildExpensesChart(expensesByCategory),

                const SizedBox(height: AppSpacing.lg),

                // Desglose por Categoría
                Text(
                  'Desglose de Gastos',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.md),

                if (expensesByCategory.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Text(
                        'Sin gastos en este período',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[500],
                            ),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: expensesByCategory.length,
                    itemBuilder: (context, index) {
                      final categoryId =
                          expensesByCategory.keys.elementAt(index);
                      final amount = expensesByCategory[categoryId]!;
                      final percentage = (amount / monthlyExpense) * 100;
                      final category = Category.getCategoryById(categoryId);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(AppBorderRadius.md),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    category.icon,
                                    color: category.color,
                                    size: 28,
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          category.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        Text(
                                          '\$${amount.toStringAsFixed(2)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${percentage.toStringAsFixed(1)}%',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: category.color,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(AppBorderRadius.sm),
                                child: LinearProgressIndicator(
                                  value: percentage / 100,
                                  minHeight: 6,
                                  backgroundColor: Colors.grey[200],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    category.color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _previousMonth,
        ),
        Text(
          DateFormatter.formatMonthYear(
            DateTime(_selectedYear, _selectedMonth),
          ),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _nextMonth,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    double amount,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesChart(Map<String, double> expensesByCategory) {
    final List<PieChartSectionData> sections = [];
    double total = expensesByCategory.values.fold(0, (sum, val) => sum + val);

    expensesByCategory.forEach((categoryId, amount) {
      final category = Category.getCategoryById(categoryId);
      sections.add(
        PieChartSectionData(
          value: amount,
          color: category.color,
          title: '${((amount / total) * 100).toStringAsFixed(0)}%',
          radius: 100,
          titleStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      );
    });

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gastos por Categoría',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 0,
                sectionsSpace: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth--;
      if (_selectedMonth < 1) {
        _selectedMonth = 12;
        _selectedYear--;
      }
    });
  }

  void _nextMonth() {
    final now = DateTime.now();
    if (_selectedYear < now.year ||
        (_selectedYear == now.year && _selectedMonth < now.month)) {
      setState(() {
        _selectedMonth++;
        if (_selectedMonth > 12) {
          _selectedMonth = 1;
          _selectedYear++;
        }
      });
    }
  }
}
