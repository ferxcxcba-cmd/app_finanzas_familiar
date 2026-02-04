# 🔧 DIAGRAMA DETALLADO DE COMPONENTES

## 1. ESTRUCTURA DE CARPETAS

```
app_finanzas_familiar/
│
├── lib/
│   ├── main.dart                              ← Punto de entrada principal
│   │
│   ├── models/                                ← CAPA DE DATOS
│   │   ├── transaction.dart                  (Ingreso/Gasto)
│   │   ├── category.dart                     (Categorías con iconos)
│   │   ├── budget.dart                       (Presupuestos mensuales)
│   │   └── savings_goal.dart                 (Metas de ahorro)
│   │
│   ├── services/                              ← CAPA DE SERVICIOS
│   │   ├── database_service.dart             (SQLite - Local)
│   │   │   ├── insertTransaction()
│   │   │   ├── getTransactions()
│   │   │   ├── updateTransaction()
│   │   │   ├── deleteTransaction()
│   │   │   ├── insertBudget()
│   │   │   ├── insertSavingsGoal()
│   │   │   └── ... (más métodos)
│   │   │
│   │   └── sync_service.dart                 (Firebase - Cloud)
│   │       ├── syncTransaction()
│   │       ├── getRemoteTransactions()
│   │       ├── syncBudget()
│   │       ├── addFamilyMember()
│   │       └── transactionStream()
│   │
│   ├── providers/                              ← CAPA DE ESTADO
│   │   ├── transaction_provider.dart
│   │   │   ├── transactions: List<Transaction>
│   │   │   ├── balance: double
│   │   │   ├── totalIncome: double
│   │   │   ├── totalExpense: double
│   │   │   ├── addTransaction()
│   │   │   ├── updateTransaction()
│   │   │   ├── deleteTransaction()
│   │   │   ├── getExpensesByCategory()
│   │   │   └── syncWithRemote()
│   │   │
│   │   ├── budget_provider.dart
│   │   │   ├── budgets: List<Budget>
│   │   │   ├── createBudget()
│   │   │   ├── updateBudgetSpent()
│   │   │   ├── getBudgetsExceeded()
│   │   │   └── changeMonth()
│   │   │
│   │   └── savings_provider.dart
│   │       ├── goals: List<SavingsGoal>
│   │       ├── activeGoals
│   │       ├── totalSaved: double
│   │       ├── overallProgress: double
│   │       ├── createGoal()
│   │       ├── addToGoal()
│   │       └── deleteGoal()
│   │
│   ├── screens/                                ← CAPA DE PRESENTACIÓN
│   │   ├── home_screen.dart
│   │   │   ├── BalanceCard
│   │   │   ├── RecentTransactions
│   │   │   ├── BudgetAlerts
│   │   │   └── BottomNavigation
│   │   │
│   │   ├── add_transaction_screen.dart
│   │   │   ├── TypeSelector (Income/Expense)
│   │   │   ├── AmountInput
│   │   │   ├── DescriptionInput
│   │   │   ├── CategorySelector
│   │   │   ├── DatePicker
│   │   │   └── NotesInput
│   │   │
│   │   ├── analytics_screen.dart
│   │   │   ├── MonthNavigator
│   │   │   ├── SummaryCards (Income/Expense)
│   │   │   ├── PieChart (fl_chart)
│   │   │   └── CategoryBreakdown
│   │   │
│   │   ├── budgets_screen.dart
│   │   │   ├── SummaryCard
│   │   │   ├── AddBudgetButton
│   │   │   ├── BudgetsList
│   │   │   └── ProgressBars
│   │   │
│   │   └── savings_screen.dart
│   │       ├── SummaryCard
│   │       ├── OverallProgressBar
│   │       ├── ActiveGoals
│   │       ├── CompletedGoals
│   │       └── AddGoalButton
│   │
│   ├── widgets/                                ← COMPONENTES REUTILIZABLES
│   │   ├── balance_card.dart
│   │   │   └── Muestra: Saldo Total, Ingresos, Egresos
│   │   │
│   │   ├── transaction_item.dart
│   │   │   └── Muestra: Icono, Descripción, Monto, Fecha
│   │   │
│   │   └── category_selector.dart
│   │       └── Grid de categorías con selección
│   │
│   ├── theme/
│   │   └── app_theme.dart
│   │       ├── lightTheme()
│   │       ├── ColorScheme
│   │       ├── TextThemes
│   │       ├── InputDecorations
│   │       └── ButtonStyles
│   │
│   └── utils/
│       ├── constants.dart
│       │   ├── AppColors
│       │   ├── AppSpacing
│       │   ├── AppBorderRadius
│       │   └── AppShadows
│       │
│       ├── formatters.dart
│       │   ├── CurrencyFormatter
│       │   ├── DateFormatter
│       │   └── PercentageFormatter
│       │
│       └── validators.dart
│           ├── validateAmount()
│           ├── validateDescription()
│           ├── validateEmail()
│           └── validateGoalTitle()
│
├── pubspec.yaml                               ← Dependencias
└── README.md
```

## 2. FLUJO DE DATOS DETALLADO

### Agregar Transacción
```
User Action (Add Button)
           ↓
   AddTransactionScreen
           ↓
   Form Validation
           ↓
   TransactionProvider.addTransaction()
           ↓
       ┌───┴───┐
       ▼       ▼
  SQLite   Firebase
  (Offline) (Sync)
       └───┬───┘
           ↓
  notifyListeners()
           ↓
  Home Screen Rebuilds
           ↓
  BalanceCard Updates
  TransactionList Updates
```

### Actualizar Presupuesto
```
TransactionProvider.addTransaction() (Expense)
           ↓
  Trigger BudgetProvider.updateBudgetSpent()
           ↓
  Calculate spent + new transaction
           ↓
  Compare with limit
           ↓
  ┌─────────┴─────────┐
  ▼                   ▼
Within Limit    Exceeded Limit
  │                   │
  ▼                   ▼
Update DB        Show Alert
Notify UI        Update UI
```

### Sincronizar Datos
```
Online Status Detected
           ↓
Trigger Sync
           ↓
   ┌──────┬──────┬──────┐
   ▼      ▼      ▼      ▼
Trans  Budgets Goals   User
   │      │      │      │
   └──────┴──────┴──────┘
           ▼
  SyncService.syncXxx()
           ▼
  Firebase Firestore
           ▼
  Update Remote Data
           ▼
  Fetch Remote Changes
           ▼
  Update Local DB
           ▼
  Notify Providers
           ▼
  UI Refresh
```

## 3. CICLO DE VIDA DE DATOS

### Transacción Típica

**1. Captura**
```dart
// Usuario ingresa:
- Tipo: Expense
- Monto: $50
- Categoría: Food
- Fecha: Hoy
- Descripción: "Almuerzo"
- Notas: "Restaurant downtown"
```

**2. Validación**
```dart
- Monto > 0? ✅
- Descripción no vacía? ✅
- Categoría válida? ✅
```

**3. Almacenamiento Local**
```dart
DatabaseService.insertTransaction()
  → sqflite INSERT
  → Tabla: transactions
  → Row: {id, desc, amount, type, category, date, userId, notes, isRecurring}
```

**4. Sincronización Remota**
```dart
SyncService.syncTransaction()
  → Firebase.users/{userId}/transactions/{id}
  → Firestore document con datos transaccionales
```

**5. Actualización de Estado**
```dart
TransactionProvider.notifyListeners()
  → Recalcular balance
  → Recalcular totalIncome/totalExpense
  → Widget rebuild
```

**6. Actualización de Presupuesto**
```dart
BudgetProvider.updateBudgetSpent()
  → Buscar presupuesto de "Food"
  → Sumar nuevo gasto: spent = spent + 50
  → Guardar en DB
  → Sincronizar con Firebase
```

**7. Actualización de UI**
```dart
- Home Screen: saldo actualizado
- Balance Card: números nuevos
- Transaction List: nuevo item visible
- Analytics: gráfico actualizado
- Budget: progreso de Food aumentado
```

## 4. MATRIZ DE FUNCIONES

| Pantalla | Componentes | Providers | Servicios |
|----------|------------|-----------|-----------|
| **Home** | BalanceCard, TransactionItem, BudgetAlert | Transaction, Budget | Database, Sync |
| **Add Transaction** | TypeSelector, AmountInput, CategorySelector, DatePicker | Transaction, Budget | Database, Sync |
| **Analytics** | MonthNavigator, SummaryCard, PieChart, CategoryItem | Transaction | Database |
| **Budgets** | SummaryCard, BudgetCard, AddDialog, ProgressBar | Budget, Transaction | Database, Sync |
| **Savings** | SummaryCard, GoalCard, AddDialog, ProgressBar | Savings | Database, Sync |

## 5. INTERACCIONES PRINCIPALES

### Scenario: Usuario agrega gasto de $50 en Food

1. **Tap en +** → Abre AddTransactionScreen
2. **Selecciona Expense**
3. **Ingresa 50** → CurrencyFormatter.parse("50")
4. **Selecciona Food** → Category.id = "food"
5. **Selecciona hoy** → DateTime.now()
6. **Tap Guardar**
   - Form validation ✅
   - TransactionProvider.addTransaction()
   - Transaction object created
   - DatabaseService.insertTransaction()
   - SyncService.syncTransaction()
   - BudgetProvider.updateBudgetSpent()
   - Ambos notifyListeners()
   - SnackBar: "Guardado"
   - Pop back to Home
   - UI refresh automático

### Scenario: Usuario crea presupuesto de $200 para Food

1. **En Budgets Screen**
2. **Tap "Nuevo Presupuesto"** → Dialog
3. **Selecciona Food**
4. **Ingresa 200** → Validators.validateBudgetLimit()
5. **Tap Guardar**
   - Form validation ✅
   - BudgetProvider.createBudget()
   - Budget object created
   - DatabaseService.insertBudget()
   - SyncService.syncBudget()
   - notifyListeners()
   - Budget lista actualizada
   - Dialog cierra

### Scenario: Usuario crea meta de ahorro de $1000 para Viaje

1. **En Savings Screen**
2. **Tap "Nueva Meta"** → Dialog
3. **Ingresa:**
   - Título: "Viaje a playa"
   - Descripción: "Vacaciones familia"
   - Monto: $1000
   - Fecha: 3 meses
4. **Tap Crear**
   - SavingsProvider.createGoal()
   - SavingsGoal object created
   - DatabaseService.insertSavingsGoal()
   - SyncService.syncSavingsGoal()
   - Goal aparece en lista
5. **Usuario agrega dinero:**
   - Tap en goal
   - Tap "Agregar Dinero"
   - Ingresa: $50
   - SavingsProvider.addToGoal()
   - currentAmount = 50
   - progress = 5%
   - notifyListeners()
   - Goal card actualizada

## 6. ESTADO DE WIDGETS (TreeView)

```
MyApp
├── MaterialApp
│   ├── themeData: AppTheme.lightTheme()
│   └── home: HomeScreen
│       └── MultiProvider
│           ├── TransactionProvider
│           ├── BudgetProvider
│           ├── SavingsProvider
│           └── Scaffold
│               ├── AppBar
│               ├── body: IndexedStack
│               │   ├── Index 0: _buildHomeTab()
│               │   │   ├── SingleChildScrollView
│               │   │   │   └── Column
│               │   │   │       ├── BalanceCard (Consumer<TransactionProvider>)
│               │   │   │       ├── "Transacciones Recientes"
│               │   │   │       └── ListView.builder<TransactionItem>
│               │   │   │
│               │   ├── Index 1: AnalyticsScreen
│               │   │   ├── AppBar
│               │   │   └── SingleChildScrollView
│               │   │       └── Column
│               │   │           ├── MonthSelector
│               │   │           ├── SummaryCards (Row)
│               │   │           └── PieChart
│               │   │
│               │   ├── Index 2: BudgetsScreen
│               │   │   ├── AppBar
│               │   │   └── Consumer<BudgetProvider>
│               │   │       └── ListView<BudgetCard>
│               │   │
│               │   └── Index 3: SavingsScreen
│               │       ├── AppBar
│               │       └── Consumer<SavingsProvider>
│               │           ├── SummaryCard
│               │           └── ListView<GoalCard>
│               │
│               ├── FloatingActionButton (+)
│               └── BottomNavigationBar
│                   └── 4 items (Home, Analytics, Budgets, Savings)
```

## 7. TABLA DE ENDPOINTS FIREBASE

```
users/
├── {userId}/
│   ├── transactions/
│   │   └── {transactionId}: {data}
│   ├── budgets/
│   │   └── {budgetId}: {data}
│   ├── savings_goals/
│   │   └── {goalId}: {data}
│   └── profile/
│       └── {user info}
│
families/
├── {familyCode}/
│   └── members/
│       └── {email}: {joinDate, role}
```

---

Este documento es una guía completa de la arquitectura y estructura del proyecto.
