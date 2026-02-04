import 'package:flutter/material.dart';
import '../models/category.dart';

class CategorySelector extends StatefulWidget {
  final bool isIncome;
  final Function(Category) onCategorySelected;
  final String? selectedCategoryId;

  const CategorySelector({
    Key? key,
    required this.isIncome,
    required this.onCategorySelected,
    this.selectedCategoryId,
  }) : super(key: key);

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  late List<Category> categories;
  late String? selectedId;

  @override
  void initState() {
    super.initState();
    categories = widget.isIncome
        ? Category.getIncomeCategories()
        : Category.getExpenseCategories();
    selectedId = widget.selectedCategoryId;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categoría',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = selectedId == category.id;

            return GestureDetector(
              onTap: () {
                setState(() => selectedId = category.id);
                widget.onCategorySelected(category);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? category.color.withOpacity(0.2)
                      : Colors.grey[100],
                  border: Border.all(
                    color: isSelected ? category.color : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      category.icon,
                      color: category.color,
                      size: 28,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
