import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../utils/formatters.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TransactionItem({
    Key? key,
    required this.transaction,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final category = Category.getCategoryById(transaction.category);
    final isIncome = transaction.type == TransactionType.income;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                category.icon,
                color: category.color,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${category.name} • ${transaction.formattedDate}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isIncome ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isIncome ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (transaction.notes != null && transaction.notes!.isNotEmpty)
                  Text(
                    transaction.notes!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
            if (onDelete != null)
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('Eliminar'),
                    onTap: onDelete,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
