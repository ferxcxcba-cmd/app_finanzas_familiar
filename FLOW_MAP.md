# 🗺️ MAPA DE FLUJO DE LA APP

## 1. FLUJO GENERAL DE NAVEGACIÓN

```
┌─────────────────────────────────────────────────────────────┐
│                     Inicio: main.dart                       │
│                                                              │
│            Firebase.initializeApp() [Opcional]             │
│                        ↓                                    │
│                   MaterialApp                               │
│                        ↓                                    │
│              HomeScreen (userId='user123')                 │
│                        ↓                                    │
│            MultiProvider (3 Providers)                     │
│                        ↓                                    │
│              IndexedStack (4 pantallas)                    │
│                        ↓                                    │
│    ┌──────┬──────────┬──────────┬──────────┐              │
│    ↓      ↓          ↓          ↓          ↓              │
│  HOME  ANALYTICS  BUDGETS   SAVINGS                       │
│                                                              │
│    └──────┬──────────┬──────────┬──────────┘              │
│           ↓                                                 │
│    Floating Action Button (+)                              │
│           ↓                                                 │
│    AddTransactionScreen ←──────┐                           │
│           ↓                    │                           │
│      Save & Pop ───────────────┘                          │
└─────────────────────────────────────────────────────────────┘
```

## 2. ESTADO Y FLUJO DE TRANSACCIONES

```
┌──────────────────────────────────────────────────────────────┐
│                   USER INTERFACE                             │
│  (Home, Analytics, Budgets, Savings, AddTransaction)        │
└────────────────────────┬─────────────────────────────────────┘
                         │
        ┌────────────────┼────────────────┐
        │                │                │
        ▼                ▼                ▼
   TRIGGER        REBUILD UI        CONSUME
   ACTION         (via Consumer)     (listen: true)
        │                │                │
        └────────────────┼────────────────┘
                         ▼
    ┌──────────────────────────────────────┐
    │     TransactionProvider              │
    │  (extends ChangeNotifier)            │
    │                                      │
    │  Properties:                         │
    │  - transactions: List                │
    │  - totalIncome: double               │
    │  - totalExpense: double              │
    │  - balance: double                   │
    │                                      │
    │  Methods:                            │
    │  - addTransaction()                  │
    │  - updateTransaction()               │
    │  - deleteTransaction()               │
    │  - getExpensesByCategory()           │
    │  - getTransactionsByMonth()          │
    │  - syncWithRemote()                  │
    │                                      │
    │  Notifies → notifyListeners()        │
    └────────┬─────────────────────────────┘
             │
     ┌───────┴────────┐
     ▼                ▼
SQLITE           FIREBASE
 LOCAL           (Cloud)
DATABASE         SYNC
```

## 3. CICLO DE VIDA DE UNA TRANSACCIÓN

```
START: Usuario abre app
    ↓
HOME SCREEN CARGADA
    ├─ TransactionProvider.__init__()
    │  └─ _loadTransactions()
    │     └─ DatabaseService.getTransactions()
    │        └─ SQLite SELECT
    └─ UI muestra últimas 5 transacciones
    
    ↓
USUARIO: Tap en FAB (+)
    ↓
SCREEN: AddTransactionScreen abierta
    ├─ Form widgets renderizados
    └─ CategorySelector mostrado
    
    ↓
USUARIO: Completa formulario y tap "Guardar"
    ├─ Form.validate() ✅
    └─ Data extraída:
       - description: "Almuerzo"
       - amount: 45.50
       - type: TransactionType.expense
       - category: "food"
       - date: DateTime.now()
       - notes: "Restaurant"
    
    ↓
PROVIDER: TransactionProvider.addTransaction()
    ├─ Crea Transaction object
    │  └─ id = Uuid().v4()
    │
    ├─ DatabaseService.insertTransaction()
    │  ├─ Abre SQLite connection
    │  ├─ INSERT INTO transactions
    │  └─ ✅ Guardado localmente
    │
    ├─ SyncService.syncTransaction() (async)
    │  ├─ Conecta a Firebase
    │  ├─ users/{userId}/transactions/{id}
    │  └─ ✅ Sincronizado (si hay internet)
    │
    ├─ BudgetProvider.updateBudgetSpent()
    │  └─ Suma $45.50 al presupuesto de "food"
    │
    └─ notifyListeners()
       └─ Notifica todos los widgets
    
    ↓
UI: Rebuild automático
    ├─ BalanceCard: 
    │  └─ balance = oldBalance - 45.50
    ├─ TransactionList:
    │  └─ Nuevo item aparece al inicio
    └─ BudgetCard (Food):
       └─ Barra progresa de 82.5% a 83.5%
    
    ↓
FEEDBACK: SnackBar "Transacción guardada"
    ↓
NAVIGATION: Navigator.pop() → vuelve a Home
    
END
```

## 4. FLUJO DE DATOS DE PRESUPUESTOS

```
USER: "Quiero crear presupuesto de $300 para Food"
    ↓
BUTTON: "Nuevo Presupuesto"
    ↓
DIALOG: Abre con forma:
    - DropdownButtonFormField (categorías)
    - TextFormField (límite)
    ↓
USER: Selecciona "Alimentos" y escribe "300"
    ↓
VALIDATION:
    - ¿Categoría seleccionada? ✅
    - ¿Límite > 0? ✅
    ↓
PROVIDER: BudgetProvider.createBudget()
    ├─ Budget object:
    │  ├─ id: UUID
    │  ├─ category: "food"
    │  ├─ limit: 300.0
    │  ├─ spent: 0.0
    │  ├─ month: 2
    │  └─ year: 2026
    │
    ├─ DatabaseService.insertBudget()
    │  └─ INSERT INTO budgets
    │
    ├─ SyncService.syncBudget()
    │  └─ Firestore: users/{userId}/budgets/{id}
    │
    └─ notifyListeners()
    
    ↓
UI: BudgetsList rebuild
    ├─ Nuevo budget aparece
    ├─ Mostrado como:
    │  ├─ Ícono: restaurant
    │  ├─ Nombre: "Alimentos"
    │  ├─ Monto: "$0 / $300"
    │  ├─ Barra: 0%
    │  └─ Color: Naranja (color categoría)
    │
    └─ Cuando usuario gasta:
       ├─ Transacción de "food" agregada
       ├─ BudgetProvider.updateBudgetSpent()
       │  └─ spent = 0 + 45.50
       ├─ Barra progresa: 15.2%
       └─ Color permanece normal (no excede)

Si gasta más de $300:
    ├─ Budget.isExceeded = true
    ├─ Barra: Rojo
    ├─ Porcentaje: 105%
    └─ Home Screen muestra ALERTA
```

## 5. FLUJO DE DATOS DE AHORROS

```
USER: "Quiero ahorrar para un viaje"
    ↓
SCREEN: SavingsScreen → "Nueva Meta"
    ↓
DIALOG: Formulario con:
    - Título: "Viaje a Playa"
    - Descripción: "Vacaciones familia"
    - Monto objetivo: $5000
    - Fecha objetivo: (3 meses)
    ↓
PROVIDER: SavingsProvider.createGoal()
    ├─ SavingsGoal object:
    │  ├─ id: UUID
    │  ├─ title: "Viaje a Playa"
    │  ├─ description: "Vacaciones familia"
    │  ├─ targetAmount: 5000.0
    │  ├─ currentAmount: 0.0
    │  ├─ targetDate: 2026-05-04
    │  └─ isCompleted: false
    │
    ├─ DatabaseService.insertSavingsGoal()
    │  └─ INSERT INTO savings_goals
    │
    ├─ SyncService.syncSavingsGoal()
    │  └─ Firestore sync
    │
    └─ notifyListeners()
    
    ↓
UI: GoalCard aparece
    ├─ Título: "Viaje a Playa"
    ├─ Meta: "$0 / $5000"
    ├─ Progreso: 0%
    ├─ Días: 89
    └─ Botón: "Agregar Dinero"
    
    ↓
USER: Agrega $500
    ├─ Tap botón "Agregar Dinero"
    ├─ Dialog: Ingresa "$500"
    └─ Valida: $500 > 0 ✅
    
    ↓
PROVIDER: SavingsProvider.addToGoal()
    ├─ currentAmount = 0 + 500
    ├─ progress = (500 / 5000) * 100 = 10%
    ├─ Valida: progress < 100?
    │  └─ ¿isCompleted = false? ✅
    ├─ DatabaseService.updateSavingsGoal()
    └─ SyncService.syncSavingsGoal()
    
    ↓
UI: GoalCard actualizada
    ├─ Meta: "$500 / $5000"
    ├─ Progreso: 10%
    ├─ Barra: 10% llena (color verde turquesa)
    └─ Días: 89

... (Usuario agrega más dinero múltiples veces)

USER: Total ahorrado: $5000
    ↓
SISTEMA: Detecta isCompleted = true
    ├─ Quita de "Objetivos Activos"
    ├─ Mueve a "Objetivos Completados"
    ├─ Color: Verde
    ├─ Ícono: ✓ Check
    └─ Botón: Eliminado
    
    ↓
UI: SavingsScreen
    ├─ Summary actualizado:
    │  ├─ Total Ahorrado: $5000
    │  ├─ Progreso General: Aumentado
    │  └─ "Viaje a Playa" en completados
    │
    └─ Celebración visual (color verde)
```

## 6. FLUJO DE SINCRONIZACIÓN

```
ESTADO 1: OFFLINE
    ├─ Usuario realiza acciones
    ├─ Datos guardados en SQLite
    ├─ Intentos de sync fallan (silent)
    └─ App funciona normalmente
    
    ↓
EVENTO: Conexión a internet detectada
    (por connectivity_plus)
    
    ↓
SINCRONIZACIÓN:
    ├─ TransactionProvider.syncWithRemote()
    │  └─ getRemoteTransactions()
    │     └─ Stream desde Firestore
    │
    ├─ BudgetProvider.syncWithRemote()
    │  └─ getRemoteBudgets()
    │
    ├─ SavingsProvider.syncWithRemote()
    │  └─ getRemoteSavingsGoals()
    │
    └─ Merge de datos:
       ├─ Datos locales + remotos
       └─ Resolver conflictos (last-write-wins)
    
    ↓
ESTADO 2: ONLINE
    ├─ Todos los cambios sincronizados
    ├─ Datos compartidos entre dispositivos
    └─ Sincronización en tiempo real
```

## 7. ÁRBOL DE COMPONENTES COMPLETO

```
MaterialApp
├── themeData: AppTheme.lightTheme()
│   ├── primaryColor: #432267
│   ├── TextThemes (8 tipos)
│   ├── ButtonStyles
│   └── InputDecorations
│
└── home: HomeScreen(userId: 'user123')
    └── MultiProvider
        ├── ChangeNotifierProvider<TransactionProvider>
        ├── ChangeNotifierProvider<BudgetProvider>
        ├── ChangeNotifierProvider<SavingsProvider>
        │
        └── Scaffold
            ├── AppBar
            │   ├── title: "Inicio"
            │   └── actions: []
            │
            ├── body: IndexedStack
            │   │
            │   ├── [0] _buildHomeTab()
            │   │   └── SingleChildScrollView
            │   │       └── Column
            │   │           ├── BalanceCard
            │   │           │   └── Consumer<TransactionProvider>
            │   │           │       ├── totalIncome
            │   │           │       ├── totalExpense
            │   │           └── balance
            │   │           │
            │   │           ├── "Transacciones Recientes"
            │   │           │
            │   │           └── ListView.builder<TransactionItem>
            │   │               ├── Icon + Category
            │   │               ├── Description
            │   │               ├── Amount
            │   │               └── Date
            │   │           │
            │   │           └── Consumer<BudgetProvider>
            │   │               └── BudgetAlerts (si hay excedidos)
            │   │
            │   ├── [1] AnalyticsScreen
            │   │   ├── AppBar
            │   │   └── Consumer<TransactionProvider>
            │   │       ├── MonthSelector (◄ Mes ►)
            │   │       ├── SummaryCards (Row)
            │   │       │   ├── Card: Income
            │   │       │   └── Card: Expense
            │   │       └── PieChart (fl_chart)
            │   │           └── Gastos por categoría
            │   │
            │   ├── [2] BudgetsScreen
            │   │   ├── AppBar
            │   │   └── Consumer<BudgetProvider>
            │   │       ├── SummaryCard
            │   │       ├── "Nuevo Presupuesto" Button
            │   │       └── ListView<BudgetCard>
            │   │           ├── Category Icon
            │   │           ├── Spent / Limit
            │   │           └── ProgressBar
            │   │
            │   └── [3] SavingsScreen
            │       ├── AppBar
            │       └── Consumer<SavingsProvider>
            │           ├── SummaryCard
            │           │   ├── Total Ahorrado
            │           │   ├── Meta Total
            │           └── OverallProgress
            │           │
            │           ├── "Nueva Meta" Button
            │           │
            │           ├── ActiveGoals
            │           │   └── ListView<GoalCard>
            │           │       ├── Title
            │           │       ├── Saved / Target
            │           │       └── ProgressBar
            │           │
            │           └── CompletedGoals
            │               └── ListView<GoalCard>
            │                   ├── ✓ Badge
            │                   └── Green color
            │
            ├── FloatingActionButton (+)
            │   └── onPressed: AddTransactionScreen
            │
            └── BottomNavigationBar
                ├── [0] Home
                ├── [1] Analytics
                ├── [2] Budgets
                └── [3] Savings
```

## 8. FLUJO DE ERRORES Y RECUPERACIÓN

```
USER ACTION
    ↓
TRY BLOCK
    ├─ Validación ✅
    ├─ DB Insert ✅
    ├─ Sync Attempt
    │   ├─ Si Online ✅
    │   └─ Si Offline → Continúa (dato queda pendiente)
    │
    └─ notifyListeners() ✅
    
    ↓
CATCH BLOCK
    ├─ debugPrint error message
    ├─ rethrow exception
    │   └─ UI captura en .catchError()
    │
    └─ ScaffoldMessenger.showSnackBar()
        └─ Color ROJO + mensaje error
        
    ↓
RECOVERY
    ├─ Usuario puede reintentar
    ├─ Al recuperar conexión, sync automático
    └─ Datos no se pierden
```

---

Este mapa cubre todos los flujos principales de la aplicación.
