import 'package:flutter/material.dart';
import '../utils/constants.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expense;

  const BalanceCard({
    Key? key,
    required this.balance,
    required this.income,
    required this.expense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryColor, AppColors.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Saldo Total",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            '\$${balance.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIncomeExpenseItem(
                context,
                'Ingresos',
                income,
                Icons.arrow_downward,
                Colors.greenAccent,
              ),
              _buildIncomeExpenseItem(
                context,
                'Egresos',
                expense,
                Icons.arrow_upward,
                Colors.redAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseItem(
    BuildContext context,
    String label,
    double amount,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
            ),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
