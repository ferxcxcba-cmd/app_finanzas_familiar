import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/budget_provider.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../widgets/category_selector.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late FocusNode _descriptionFocus;
  late FocusNode _amountFocus;

  String _description = '';
  double _amount = 0;
  TransactionType _type = TransactionType.expense;
  late Category _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  String _notes = '';

  @override
  void initState() {
    super.initState();
    _descriptionFocus = FocusNode();
    _amountFocus = FocusNode();
    _selectedCategory = Category.getExpenseCategories().first;
  }

  @override
  void dispose() {
    _descriptionFocus.dispose();
    _amountFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Nueva Transacción'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tipo de Transacción
              _buildTypeSelector(),
              const SizedBox(height: AppSpacing.lg),

              // Monto
              TextFormField(
                focusNode: _amountFocus,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Monto',
                  hintText: '0.00',
                  prefixText: '\$ ',
                ),
                validator: Validators.validateAmount,
                onChanged: (value) {
                  _amount = double.tryParse(value) ?? 0;
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // Descripción
              TextFormField(
                focusNode: _descriptionFocus,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Ej: Compras de supermercado',
                ),
                validator: Validators.validateDescription,
                onChanged: (value) {
                  _description = value;
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // Categoría
              CategorySelector(
                isIncome: _type == TransactionType.income,
                selectedCategoryId: _selectedCategory.id,
                onCategorySelected: (category) {
                  setState(() => _selectedCategory = category);
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Fecha
              _buildDateSelector(),
              const SizedBox(height: AppSpacing.md),

              // Notas
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Notas (opcional)',
                  hintText: 'Agrega detalles adicionales',
                  maxLines: 3,
                ),
                onChanged: (value) {
                  _notes = value;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Botón de Guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveTransaction,
                  child: const Text('Guardar Transacción'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _type = TransactionType.expense),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: _type == TransactionType.expense
                        ? AppColors.errorColor.withOpacity(0.1)
                        : Colors.grey[100],
                    border: Border.all(
                      color: _type == TransactionType.expense
                          ? AppColors.errorColor
                          : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        color: _type == TransactionType.expense
                            ? AppColors.errorColor
                            : Colors.grey[400],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Egreso',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: _type == TransactionType.expense
                                  ? AppColors.errorColor
                                  : Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _type = TransactionType.income),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: _type == TransactionType.income
                        ? AppColors.successColor.withOpacity(0.1)
                        : Colors.grey[100],
                    border: Border.all(
                      color: _type == TransactionType.income
                          ? AppColors.successColor
                          : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.arrow_downward,
                        color: _type == TransactionType.income
                            ? AppColors.successColor
                            : Colors.grey[400],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Ingreso',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: _type == TransactionType.income
                                  ? AppColors.successColor
                                  : Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fecha',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate.toString().split(' ')[0],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _saveTransaction() {
    if (_formKey.currentState!.validate()) {
      final transactionProvider =
          Provider.of<TransactionProvider>(context, listen: false);
      
      transactionProvider.addTransaction(
        description: _description,
        amount: _amount,
        type: _type,
        category: _selectedCategory.id,
        date: _selectedDate,
        notes: _notes.isNotEmpty ? _notes : null,
      ).then((_) {
        // Actualizar presupuestos si es un gasto
        if (_type == TransactionType.expense) {
          final budgetProvider =
              Provider.of<BudgetProvider>(context, listen: false);
          final budget = budgetProvider.getBudgetForCategory(
            _selectedCategory.id,
          );
          if (budget != null) {
            budgetProvider.updateBudgetSpent(
              budget.id,
              budget.spent + _amount,
            );
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transacción guardada'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $error'),
            backgroundColor: AppColors.errorColor,
          ),
        );
      });
    }
  }
}
