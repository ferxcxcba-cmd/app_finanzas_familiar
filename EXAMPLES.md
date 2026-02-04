# 💡 EJEMPLOS DE USO

## 1. AGREGAR UNA TRANSACCIÓN PROGRAMÁTICAMENTE

```dart
// En un Provider o Screen
final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

await transactionProvider.addTransaction(
  description: 'Almuerzo en restaurant',
  amount: 45.50,
  type: TransactionType.expense,
  category: 'food',
  date: DateTime.now(),
  notes: 'Restaurant downtown',
  isRecurring: false,
);

// La UI se actualiza automáticamente gracias a notifyListeners()
```

## 2. ACCEDER AL BALANCE ACTUAL

```dart
// Opción 1: Usando Provider.of
final balance = Provider.of<TransactionProvider>(context).balance;

// Opción 2: Usando Consumer (mejor para ui updates)
Consumer<TransactionProvider>(
  builder: (context, transactionProvider, _) {
    return Text('Balance: \$${transactionProvider.balance}');
  },
)

// Opción 3: Sin listen (solo lectura)
final provider = Provider.of<TransactionProvider>(context, listen: false);
print('Balance: ${provider.balance}');
```

## 3. CREAR UN PRESUPUESTO

```dart
final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);

await budgetProvider.createBudget(
  category: 'food',        // ID de categoría
  limit: 300.0,            // Límite mensual
);

// El presupuesto aparecerá automáticamente en la lista
```

## 4. ACTUALIZAR GASTO DE PRESUPUESTO

```dart
final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);

// Obtener presupuesto actual
final budget = budgetProvider.getBudgetForCategory('food');

if (budget != null) {
  // Sumar nuevo gasto
  await budgetProvider.updateBudgetSpent(
    budget.id,
    budget.spent + 45.50,  // Nueva cantidad gastada
  );
}
```

## 5. CREAR META DE AHORRO

```dart
final savingsProvider = Provider.of<SavingsProvider>(context, listen: false);

await savingsProvider.createGoal(
  title: 'Viaje a Playa',
  description: 'Vacaciones con la familia',
  targetAmount: 2000.0,
  targetDate: DateTime.now().add(Duration(days: 90)),
);

// Meta aparecerá con 0% progreso
```

## 6. AGREGAR DINERO A UNA META

```dart
await savingsProvider.addToGoal(
  goalId: 'goal-uuid-123',
  amount: 200.0,
);

// Progress se actualiza automáticamente
// Si alcanza targetAmount, isCompleted = true
```

## 7. OBTENER GASTOS POR CATEGORÍA

```dart
final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

Map<String, double> expensesByCategory = transactionProvider.getExpensesByCategory();

// Resultado:
// {
//   'food': 450.50,
//   'transport': 120.00,
//   'entertainment': 75.00,
// }

expensesByCategory.forEach((category, amount) {
  print('$category: \$$amount');
});
```

## 8. OBTENER TRANSACCIONES DE UN MES

```dart
List<Transaction> monthlyTransactions = 
  transactionProvider.getTransactionsByMonth(2, 2026);

// Febrero 2026
for (var transaction in monthlyTransactions) {
  print('${transaction.description}: \$${transaction.amount}');
}
```

## 9. CONSTRUIR UN WIDGET CON TRANSACCIONES

```dart
Widget buildTransactionList(BuildContext context) {
  return Consumer<TransactionProvider>(
    builder: (context, transactionProvider, _) {
      if (transactionProvider.transactions.isEmpty) {
        return Center(child: Text('Sin transacciones'));
      }
      
      return ListView.builder(
        itemCount: transactionProvider.transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactionProvider.transactions[index];
          return TransactionItem(
            transaction: transaction,
            onDelete: () {
              transactionProvider.deleteTransaction(transaction.id);
            },
          );
        },
      );
    },
  );
}
```

## 10. DETECTAR PRESUPUESTOS EXCEDIDOS

```dart
final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);

List<Budget> exceededs = budgetProvider.getBudgetsExceeded();

if (exceededs.isNotEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('${exceededs.length} presupuestos excedidos'),
      backgroundColor: Colors.red,
    ),
  );
}
```

## 11. FORMATEAR VALORES

```dart
// Moneda
String formatted = CurrencyFormatter.format(1234.56);
// Output: \$1234.56

String compact = CurrencyFormatter.formatCompact(1500000);
// Output: 1.5M

// Fecha
String date = DateFormatter.formatDate(DateTime.now());
// Output: 04/02/2026

String shortDate = DateFormatter.formatShortDate(DateTime.now());
// Output: Hoy

String monthYear = DateFormatter.formatMonthYear(DateTime.now());
// Output: Febrero 2026

// Porcentaje
String percent = PercentageFormatter.format(75.5);
// Output: 75.5%
```

## 12. VALIDAR FORMULARIOS

```dart
// En un TextFormField:
TextFormField(
  validator: Validators.validateAmount,
  // Error: "El monto es requerido"
  // Error: "Ingresa un monto válido"
  // Error: "El monto debe ser mayor a 0"
)

TextFormField(
  validator: Validators.validateDescription,
  // Error: "La descripción es requerida"
  // Error: "La descripción debe tener al menos 3 caracteres"
)

// Manual:
String? error = Validators.validateAmount('0');
if (error != null) {
  print(error);  // "El monto debe ser mayor a 0"
}
```

## 13. SINCRONIZAR CON FIREBASE

```dart
// Transacciones
await transactionProvider.syncWithRemote();

// Presupuestos
await budgetProvider.syncWithRemote();

// Objetivos de ahorro
await savingsProvider.syncWithRemote();

// Todos los datos se actualizan desde Firestore
// Y la UI se refreshea automáticamente
```

## 14. TRABAJAR CON CATEGORÍAS

```dart
// Obtener todas las categorías de gasto
List<Category> expenseCategories = Category.getExpenseCategories();

// Obtener categoría específica
Category category = Category.getCategoryById('food');
print(category.name);      // "Alimentos"
print(category.icon);      // Icons.restaurant
print(category.color);     // Color naranja

// Usar en UI
Icon(
  category.icon,
  color: category.color,
  size: 32,
)
```

## 15. CREAR DIÁLOGO PERSONALIZADO

```dart
showDialog(
  context: context,
  builder: (context) {
    String amount = '';
    return AlertDialog(
      title: Text('Agregar Dinero'),
      content: TextFormField(
        keyboardType: TextInputType.number,
        onChanged: (value) => amount = value,
        decoration: InputDecoration(
          labelText: 'Monto',
          prefixText: '\$ ',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (amount.isNotEmpty) {
              // Hacer algo
              Navigator.pop(context);
            }
          },
          child: Text('Agregar'),
        ),
      ],
    );
  },
);
```

## 16. MOSTRAR SNACKBAR

```dart
// Éxito
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Transacción guardada'),
    duration: Duration(seconds: 2),
    backgroundColor: Colors.green,
  ),
);

// Error
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Error: No se pudo guardar'),
    backgroundColor: Colors.red,
  ),
);
```

## 17. NAVEGAR A OTRA PANTALLA

```dart
// Ir a otra pantalla
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => AddTransactionScreen(),
  ),
);

// Volver a pantalla anterior
Navigator.of(context).pop();

// Pop con resultado
Navigator.of(context).pop(resultData);
```

## 18. TEMA Y ESTILOS

```dart
// Usar estilos de tema
Text(
  'Título',
  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  ),
)

// Colores
Container(
  color: AppColors.primaryColor,
  child: Text('Purple background'),
)

// Espaciado
Padding(
  padding: EdgeInsets.all(AppSpacing.md),  // 16
  child: Text('Content'),
)

// Border Radius
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(AppBorderRadius.lg),  // 16
  ),
)
```

## 19. USAR CONSUMER PARA MÚLTIPLES PROVIDERS

```dart
Widget build(BuildContext context) {
  return Consumer3<TransactionProvider, BudgetProvider, SavingsProvider>(
    builder: (context, transProvider, budgetProvider, savingsProvider, _) {
      return Column(
        children: [
          Text('Balance: \$${transProvider.balance}'),
          Text('Presupuestado: \$${budgetProvider.getTotalBudgeted()}'),
          Text('Ahorrado: \$${savingsProvider.totalSaved}'),
        ],
      );
    },
  );
}
```

## 20. DEBUGGING CON PRINT

```dart
// En TransactionProvider:
debugPrint('Agregando transacción: $description');
debugPrint('Monto: $amount');
debugPrint('Balance antes: ${balance}');
await _dbService.insertTransaction(transaction);
debugPrint('Guardado en DB');
await _syncService.syncTransaction(transaction);
debugPrint('Sincronizado con Firebase');
notifyListeners();
debugPrint('Listeners notificados');

// Ver en consola:
// I/flutter (12345): Agregando transacción: Almuerzo
// I/flutter (12345): Monto: 45.5
// ...
```

---

## 🎯 CASOS DE USO REALES

### Caso 1: Usuario que almuerza y gasta $45

```dart
final provider = Provider.of<TransactionProvider>(context, listen: false);
await provider.addTransaction(
  description: 'Almuerzo',
  amount: 45.0,
  type: TransactionType.expense,
  category: 'food',
  date: DateTime.now(),
);
// Automáticamente:
// - Se guarda en SQLite
// - Se sincroniza con Firebase
// - Balance = balance - 45
// - Presupuesto de Food se actualiza
// - UI se refreshea
```

### Caso 2: Familia quiere ahorrar para un viaje

```dart
// Mamá crea meta
await savingsProvider.createGoal(
  title: 'Viaje a Playa',
  description: 'Vacaciones familia',
  targetAmount: 5000.0,
  targetDate: DateTime.now().add(Duration(days: 180)),
);

// Papá agrega dinero
await savingsProvider.addToGoal(goalId, 1000.0);

// Hijos agregan dinero
await savingsProvider.addToGoal(goalId, 500.0);

// Total ahorrado: $1500
// Progreso: 30%
// Días restantes: 176
```

### Caso 3: Presupuesto excedido

```dart
// Budget creado: Food = $300
// Usuario gasta: $250 (83%)
// Usuario gasta más: $100 (133%)
// Home Screen muestra ALERTA
// Color de barra = ROJO
```

---

**Estos ejemplos cubren el 90% de los casos de uso reales en la app.**
