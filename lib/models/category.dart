import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final String type; // 'income' or 'expense'

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });

  static List<Category> getExpenseCategories() {
    return [
      Category(
        id: 'food',
        name: 'Alimentos',
        icon: Icons.restaurant,
        color: Colors.orange,
        type: 'expense',
      ),
      Category(
        id: 'transport',
        name: 'Transporte',
        icon: Icons.directions_car,
        color: Colors.blue,
        type: 'expense',
      ),
      Category(
        id: 'utilities',
        name: 'Servicios',
        icon: Icons.home,
        color: Colors.green,
        type: 'expense',
      ),
      Category(
        id: 'entertainment',
        name: 'Entretenimiento',
        icon: Icons.movie,
        color: Colors.purple,
        type: 'expense',
      ),
      Category(
        id: 'health',
        name: 'Salud',
        icon: Icons.local_hospital,
        color: Colors.red,
        type: 'expense',
      ),
      Category(
        id: 'education',
        name: 'Educación',
        icon: Icons.school,
        color: Colors.indigo,
        type: 'expense',
      ),
      Category(
        id: 'shopping',
        name: 'Compras',
        icon: Icons.shopping_bag,
        color: Colors.pink,
        type: 'expense',
      ),
      Category(
        id: 'other',
        name: 'Otros',
        icon: Icons.category,
        color: Colors.grey,
        type: 'expense',
      ),
    ];
  }

  static List<Category> getIncomeCategories() {
    return [
      Category(
        id: 'salary',
        name: 'Salario',
        icon: Icons.attach_money,
        color: Colors.green,
        type: 'income',
      ),
      Category(
        id: 'bonus',
        name: 'Bonificación',
        icon: Icons.card_giftcard,
        color: Colors.lightGreen,
        type: 'income',
      ),
      Category(
        id: 'freelance',
        name: 'Freelance',
        icon: Icons.work,
        color: Colors.teal,
        type: 'income',
      ),
      Category(
        id: 'investment',
        name: 'Inversión',
        icon: Icons.trending_up,
        color: Colors.amber,
        type: 'income',
      ),
      Category(
        id: 'gift',
        name: 'Regalo',
        icon: Icons.card_giftcard,
        color: Colors.deepOrange,
        type: 'income',
      ),
      Category(
        id: 'other_income',
        name: 'Otro Ingreso',
        icon: Icons.category,
        color: Colors.grey,
        type: 'income',
      ),
    ];
  }

  static Category getCategoryById(String id) {
    final allCategories = [...getExpenseCategories(), ...getIncomeCategories()];
    return allCategories.firstWhere(
      (cat) => cat.id == id,
      orElse: () => Category(
        id: 'unknown',
        name: 'Desconocido',
        icon: Icons.help,
        color: Colors.grey,
        type: 'expense',
      ),
    );
  }
}
