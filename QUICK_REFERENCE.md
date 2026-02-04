# 📖 GUÍA RÁPIDA DE REFERENCIA

## 🚀 Inicio Rápido

### 1. Instalar dependencias
```bash
cd app_finanzas_familiar
flutter pub get
```

### 2. Ejecutar la app
```bash
flutter run
```

### 3. (Opcional) Configurar Firebase
```bash
flutterfire configure
```

---

## 🎯 FUNCIONES PRINCIPALES POR PANTALLA

### HOME SCREEN (Dashboard)
**Archivo:** `lib/screens/home_screen.dart`

```dart
// Lo que ve el usuario:
- Tarjeta de saldo total (Ingreso - Gasto)
- Últimas 5 transacciones
- Alertas de presupuesto excedido
- 4 botones de navegación

// Lógica:
- Consumer<TransactionProvider> → Obtiene datos de transacciones
- Muestra balance calculado en tiempo real
- Botón FAB para agregar nueva transacción
```

### ADD TRANSACTION (Agregar Transacción)
**Archivo:** `lib/screens/add_transaction_screen.dart`

```dart
// Campos:
- Tipo: Ingreso/Egreso (selector visual)
- Monto: Double con validación
- Descripción: String (3+ chars)
- Categoría: 8 opciones con iconos
- Fecha: DatePicker (default: hoy)
- Notas: Opcional

// Al guardar:
1. Valida formulario
2. Crea objeto Transaction con UUID
3. DatabaseService.insertTransaction()
4. SyncService.syncTransaction() (async)
5. BudgetProvider actualiza gasto
6. Notifica a todos los listeners
```

### ANALYTICS SCREEN (Análisis)
**Archivo:** `lib/screens/analytics_screen.dart`

```dart
// Características:
- Selector de mes/año (navegación)
- Tarjetas de ingresos y egresos
- Gráfico de pastel (fl_chart)
- Desglose por categoría con barras

// Datos mostrados:
- Total ingreso del mes
- Total egreso del mes
- % de gasto por categoría
- Visualización con colores
```

### BUDGETS SCREEN (Presupuestos)
**Archivo:** `lib/screens/budgets_screen.dart`

```dart
// Funciones:
- Ver resumen: Total presupuestado vs gastado
- Crear nuevo presupuesto por categoría
- Barra de progreso por categoría
- Alertas si excede el límite

// Cada presupuesto muestra:
- Ícono de categoría
- Nombre categoría
- $Gastado / $Límite
- % de uso
- Barra de progreso (color si excede)
```

### SAVINGS SCREEN (Plan de Ahorros)
**Archivo:** `lib/screens/savings_screen.dart`

```dart
// Características:
- Tarjeta resumen: Total ahorrado vs meta
- Barra de progreso general
- Lista de objetivos activos
- Lista de objetivos completados

// Para cada objetivo:
- Título + Descripción
- $Ahorrado / $Meta
- Días restantes
- % completado
- Botón: Agregar dinero
- Botón: Eliminar

// Crear objetivo:
- Título (3+ chars)
- Descripción (opcional)
- Monto objetivo
- Fecha objetivo (DatePicker)
```

---

## 📊 ESTRUCTURAS DE DATOS

### Transaction
```dart
Transaction {
  id: String (UUID),
  description: String,
  amount: double,
  type: TransactionType (income/expense),
  category: String (id de categoría),
  date: DateTime,
  userId: String,
  notes: String?,
  isRecurring: bool,
  
  // Propiedades calculadas:
  formattedAmount: String (\$##.##)
  formattedDate: String (dd/MM/yyyy)
}
```

### Budget
```dart
Budget {
  id: String (UUID),
  category: String (id),
  limit: double,
  spent: double,
  month: int (1-12),
  year: int,
  userId: String,
  
  // Propiedades calculadas:
  remaining: double (limit - spent)
  percentage: double (spent/limit * 100)
  isExceeded: bool (spent > limit)
}
```

### SavingsGoal
```dart
SavingsGoal {
  id: String (UUID),
  title: String,
  description: String,
  targetAmount: double,
  currentAmount: double,
  createdDate: DateTime,
  targetDate: DateTime,
  userId: String,
  isCompleted: bool,
  
  // Propiedades calculadas:
  progress: double (0-100%)
  remaining: double (target - current)
  daysRemaining: int
  isOverdue: bool
}
```

### Category
```dart
Category {
  id: String,
  name: String,
  icon: IconData,
  color: Color,
  type: String ('income' / 'expense'),
  
  // Métodos estáticos:
  getExpenseCategories(): List<Category>
  getIncomeCategories(): List<Category>
  getCategoryById(id): Category
}
```

---

## 🔌 PROVIDERS (State Management)

### TransactionProvider
```dart
// Propiedades:
- transactions: List<Transaction>
- totalIncome: double
- totalExpense: double
- balance: double

// Métodos:
- addTransaction()
- updateTransaction()
- deleteTransaction()
- getTransactionsByCategory()
- getTransactionsByMonth()
- getExpensesByCategory()
- syncWithRemote()

// Uso:
final provider = Provider.of<TransactionProvider>(context);
final balance = provider.balance;
provider.addTransaction(...);
```

### BudgetProvider
```dart
// Propiedades:
- budgets: List<Budget>

// Métodos:
- createBudget()
- updateBudgetSpent()
- deleteBudget()
- changeMonth()
- getBudgetForCategory()
- getBudgetsExceeded()
- getTotalBudgeted()
- getTotalSpent()

// Uso:
Consumer<BudgetProvider>(
  builder: (context, provider, _) {
    return ListView(children: provider.budgets);
  }
)
```

### SavingsProvider
```dart
// Propiedades:
- goals: List<SavingsGoal>
- activeGoals: List<SavingsGoal>
- completedGoals: List<SavingsGoal>
- totalTargeted: double
- totalSaved: double
- overallProgress: double

// Métodos:
- createGoal()
- addToGoal()
- deleteGoal()
- getGoalById()
- syncWithRemote()
```

---

## 🛠️ SERVICIOS

### DatabaseService (SQLite Local)
```dart
// Tabla: transactions
- insertTransaction(Transaction)
- getTransactions(userId): List<Transaction>
- updateTransaction(Transaction)
- deleteTransaction(id)

// Tabla: budgets
- insertBudget(Budget)
- getBudgets(userId, month, year): List<Budget>
- updateBudget(Budget)
- deleteBudget(id)

// Tabla: savings_goals
- insertSavingsGoal(SavingsGoal)
- getSavingsGoals(userId): List<SavingsGoal>
- updateSavingsGoal(SavingsGoal)
- deleteSavingsGoal(id)
```

### SyncService (Firebase Firestore)
```dart
// Sincronización:
- syncTransaction(Transaction)
- getRemoteTransactions(userId): List<Transaction>
- syncBudget(Budget)
- getRemoteBudgets(userId): List<Budget>
- syncSavingsGoal(SavingsGoal)
- getRemoteSavingsGoals(userId): List<SavingsGoal>

// Familiar:
- addFamilyMember(userId, familyCode, email)
- getFamilyMembers(familyCode): List<String>

// Streaming:
- transactionStream(userId): Stream<List<Transaction>>
- budgetStream(userId): Stream<List<Budget>>
```

---

## 🎨 UTILIDADES

### Constants (AppColors, AppSpacing, etc)
```dart
// Colores:
AppColors.primaryColor       // #432267 (Púrpura)
AppColors.secondaryColor     // #5862D5 (Azul)
AppColors.accentColor        // #1ABC9C (Verde)
AppColors.successColor       // #27AE60 (Verde oscuro)
AppColors.errorColor         // #E74C3C (Rojo)

// Espaciado:
AppSpacing.xs   // 4
AppSpacing.sm   // 8
AppSpacing.md   // 16
AppSpacing.lg   // 24
AppSpacing.xl   // 32

// Border Radius:
AppBorderRadius.sm    // 8
AppBorderRadius.md    // 12
AppBorderRadius.lg    // 16
AppBorderRadius.xl    // 24
```

### Formatters
```dart
// Moneda:
CurrencyFormatter.format(100.50)           // \$100.50
CurrencyFormatter.formatCompact(1500)      // 1.5K

// Fecha:
DateFormatter.formatDate(DateTime.now())      // 04/02/2026
DateFormatter.formatDateTime(...)             // 04/02/2026 14:30
DateFormatter.formatShortDate(...)            // Hoy / Ayer / 4 Feb

// Porcentaje:
PercentageFormatter.format(75.5)           // 75.5%
```

### Validators
```dart
Validators.validateAmount(value)          // > 0
Validators.validateDescription(value)     // 3+ chars
Validators.validateEmail(value)           // Email válido
Validators.validateGoalTitle(value)       // 3+ chars
```

---

## 📱 WIDGETS REUTILIZABLES

### BalanceCard
```dart
BalanceCard(
  balance: 5000.0,
  income: 7500.0,
  expense: 2500.0,
)
// Muestra: Total, Ingresos, Egresos con colores
```

### TransactionItem
```dart
TransactionItem(
  transaction: transaction,
  onTap: () {},
  onDelete: () {},
)
// Muestra: Ícono, Descripción, Monto, Fecha
```

### CategorySelector
```dart
CategorySelector(
  isIncome: false,
  selectedCategoryId: 'food',
  onCategorySelected: (category) {},
)
// Grid de 4 categorías por fila
```

---

## 🔄 FLUJOS COMUNES

### Agregar Transacción
1. User: Tap FAB (+)
2. Open: AddTransactionScreen
3. User: Completa formulario
4. Validation: Form.validate()
5. Provider: TransactionProvider.addTransaction()
6. Database: DatabaseService.insertTransaction()
7. Sync: SyncService.syncTransaction()
8. Update: BudgetProvider.updateBudgetSpent()
9. Notify: notifyListeners()
10. UI: Rebuild automático
11. Feedback: SnackBar + Pop

### Ver Análisis
1. User: Tap "Análisis" en nav bar
2. Open: AnalyticsScreen
3. Provider: Consumer<TransactionProvider>
4. Data: getTransactionsByMonth()
5. Calc: Sum by category
6. Draw: PieChart + BarCharts
7. Update: User navega meses

### Crear Presupuesto
1. User: Tap "Nuevo Presupuesto"
2. Dialog: AlertDialog Form
3. User: Selecciona categoría + monto
4. Validation: validateBudgetLimit()
5. Provider: BudgetProvider.createBudget()
6. Database: insertBudget()
7. Sync: syncBudget()
8. UI: Budget aparece en lista

---

## 🐛 DEBUGGING

### Ver logs en consola
```dart
debugPrint('Message: $variable');
```

### Inspeccionar estado provider
```dart
final provider = Provider.of<TransactionProvider>(context, listen: false);
debugPrint('Balance: ${provider.balance}');
```

### Validar datos en Firebase
```
Firebase Console → Firestore → users → {userId} → collections
```

---

## ✅ CHECKLIST DE FEATURES

- [x] Dashboard con saldo total
- [x] Registro de transacciones
- [x] Categorización
- [x] Gráficos y análisis
- [x] Presupuestos mensuales
- [x] Plan de ahorros
- [x] Base de datos local (SQLite)
- [x] Sincronización (Firebase)
- [ ] Autenticación completa
- [ ] Notificaciones push
- [ ] Modo oscuro
- [ ] Multi-idioma

---

## 📞 REFERENCIAS

- [Flutter Docs](https://flutter.dev/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [fl_chart](https://pub.dev/packages/fl_chart)
- [Firebase for Flutter](https://firebase.flutter.dev)
- [Material Design 3](https://m3.material.io)

---

**Última actualización:** 04/02/2026
