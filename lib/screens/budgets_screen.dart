import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';
import '../models/category.dart';
import '../utils/constants.dart';

class BudgetsScreen extends StatefulWidget {
  const BudgetsScreen({Key? key}) : super(key: key);

  @override
  State<BudgetsScreenState> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends State<BudgetsScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCategory = '';
  double _budgetLimit = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Presupuestos'),
      ),
      body: Consumer<BudgetProvider>(
        builder: (context, budgetProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Resumen
                Container(
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
                        'Presupuesto Total',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\$${budgetProvider.getTotalBudgeted().toStringAsFixed(2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'Presupuestado',
                                style:
                                    Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\$${budgetProvider.getTotalSpent().toStringAsFixed(2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                              ),
                              Text(
                                'Gastado',
                                style:
                                    Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Botón para agregar presupuesto
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _showAddBudgetDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Nuevo Presupuesto'),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Lista de Presupuestos
                Text(
                  'Presupuestos del Mes',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.md),

                if (budgetProvider.budgets.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Text(
                        'Sin presupuestos definidos',
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
                    itemCount: budgetProvider.budgets.length,
                    itemBuilder: (context, index) {
                      final budget = budgetProvider.budgets[index];
                      final category = Category.getCategoryById(budget.category);
                      final percentage = budget.percentage;
                      final isExceeded = budget.isExceeded;

                      return Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.md),
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: isExceeded
                              ? AppColors.errorColor.withOpacity(0.05)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(AppBorderRadius.md),
                          border: Border.all(
                            color: isExceeded
                                ? AppColors.errorColor.withOpacity(0.3)
                                : Colors.grey[200]!,
                          ),
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
                                        '\$${budget.spent.toStringAsFixed(2)} / \$${budget.limit.toStringAsFixed(2)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: isExceeded
                                                  ? AppColors.errorColor
                                                  : Colors.grey[600],
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${percentage.toStringAsFixed(0)}%',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isExceeded
                                            ? AppColors.errorColor
                                            : category.color,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(AppBorderRadius.sm),
                              child: LinearProgressIndicator(
                                value:
                                    (percentage / 100).clamp(0.0, 1.0),
                                minHeight: 8,
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isExceeded
                                      ? AppColors.errorColor
                                      : category.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddBudgetDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuevo Presupuesto'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedCategory.isEmpty ? null : _selectedCategory,
                  items: Category.getExpenseCategories()
                      .map((cat) => DropdownMenuItem(
                            value: cat.id,
                            child: Text(cat.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedCategory = value ?? '');
                  },
                  decoration: const InputDecoration(labelText: 'Categoría'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecciona una categoría';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Límite de Presupuesto',
                    prefixText: '\$ ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El límite es requerido';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Ingresa un monto válido';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _budgetLimit = double.tryParse(value) ?? 0;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: _saveBudget,
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _saveBudget() {
    if (_formKey.currentState!.validate()) {
      final budgetProvider =
          Provider.of<BudgetProvider>(context, listen: false);
      budgetProvider.createBudget(
        category: _selectedCategory,
        limit: _budgetLimit,
      );
      Navigator.pop(context);
      _selectedCategory = '';
      _budgetLimit = 0;
    }
  }
}
