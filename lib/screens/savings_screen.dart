import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/savings_provider.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../utils/formatters.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({Key? key}) : super(key: key);

  @override
  State<SavingsScreenState> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  double _targetAmount = 0;
  DateTime _targetDate = DateTime.now().add(const Duration(days: 30));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Plan de Ahorros'),
      ),
      body: Consumer<SavingsProvider>(
        builder: (context, savingsProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Resumen General
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        AppColors.secondaryColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Ahorrado',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        '\$${savingsProvider.totalSaved.toStringAsFixed(2)}',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Meta Total: \$${savingsProvider.totalTargeted.toStringAsFixed(2)}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppBorderRadius.sm),
                        child: LinearProgressIndicator(
                          value: (savingsProvider.overallProgress / 100)
                              .clamp(0.0, 1.0),
                          minHeight: 8,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        '${savingsProvider.overallProgress.toStringAsFixed(1)}% alcanzado',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Botón para agregar objetivo
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _showAddGoalDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Nueva Meta de Ahorro'),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Objetivos Activos
                Text(
                  'Objetivos Activos',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.md),

                if (savingsProvider.activeGoals.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Text(
                        'Sin objetivos activos',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: Colors.grey[500],
                            ),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: savingsProvider.activeGoals.length,
                    itemBuilder: (context, index) {
                      final goal = savingsProvider.activeGoals[index];
                      return _buildGoalCard(context, goal, savingsProvider);
                    },
                  ),

                const SizedBox(height: AppSpacing.lg),

                // Objetivos Completados
                if (savingsProvider.completedGoals.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Objetivos Completados',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: savingsProvider.completedGoals.length,
                        itemBuilder: (context, index) {
                          final goal = savingsProvider.completedGoals[index];
                          return _buildGoalCard(context, goal, savingsProvider,
                              completed: true);
                        },
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGoalCard(
    BuildContext context,
    dynamic goal,
    SavingsProvider savingsProvider, {
    bool completed = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: completed ? Colors.green.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(
          color: completed
              ? Colors.green.withOpacity(0.3)
              : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (goal.description.isNotEmpty)
                      Text(
                        goal.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (completed)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 24,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ahorrado',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  Text(
                    '\$${goal.currentAmount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Meta',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  Text(
                    '\$${goal.targetAmount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              if (!completed)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Días',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    Text(
                      '${goal.daysRemaining}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: goal.daysRemaining < 0
                                ? AppColors.errorColor
                                : Colors.black,
                          ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            child: LinearProgressIndicator(
              value: (goal.progress / 100).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                completed ? Colors.green : AppColors.accentColor,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${goal.progress.toStringAsFixed(1)}% alcanzado',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          if (!completed) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        _showAddAmountDialog(context, goal.id, savingsProvider),
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar Dinero'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sm),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton(
                  onPressed: () =>
                      savingsProvider.deleteGoal(goal.id),
                  icon: const Icon(Icons.delete),
                  color: AppColors.errorColor,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showAddGoalDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nueva Meta de Ahorro'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: Validators.validateGoalTitle,
                  onChanged: (value) => _title = value,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Descripción (opcional)',
                  ),
                  maxLines: 3,
                  onChanged: (value) => _description = value,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Monto a Ahorrar',
                    prefixText: '\$ ',
                  ),
                  validator: Validators.validateAmount,
                  onChanged: (value) {
                    _targetAmount = double.tryParse(value) ?? 0;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormatter.formatDate(_targetDate),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
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
              onPressed: _saveGoal,
              child: const Text('Crear'),
            ),
          ],
        );
      },
    );
  }

  void _showAddAmountDialog(
    BuildContext context,
    String goalId,
    SavingsProvider savingsProvider,
  ) {
    String amount = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Dinero'),
          content: TextFormField(
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Monto',
              prefixText: '\$ ',
            ),
            validator: Validators.validateAmount,
            onChanged: (value) => amount = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (amount.isNotEmpty) {
                  savingsProvider.addToGoal(
                    goalId,
                    double.tryParse(amount) ?? 0,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _targetDate = picked);
    }
  }

  void _saveGoal() {
    if (_formKey.currentState!.validate()) {
      final savingsProvider =
          Provider.of<SavingsProvider>(context, listen: false);
      savingsProvider.createGoal(
        title: _title,
        description: _description,
        targetAmount: _targetAmount,
        targetDate: _targetDate,
      );
      Navigator.pop(context);
      _title = '';
      _description = '';
      _targetAmount = 0;
      _targetDate = DateTime.now().add(const Duration(days: 30));
    }
  }
}
