# 📊 Finanzas Familiar - App Flutter

Aplicación moderna de gestión de ingresos y egresos del hogar con sincronización entre dispositivos familiares.

## ✨ Características Principales

### 1. **Registro de Transacciones**
- Registro manual de ingresos y gastos
- Categorización inteligente con 8+ categorías
- Soporte para transacciones recurrentes
- Notas y detalles adicionales

### 2. **Análisis Financiero**
- Gráficos visuales con PieChart (fl_chart)
- Desglose de gastos por categoría
- Comparativas mensuales
- Análisis de tendencias

### 3. **Presupuestos Mensuales**
- Crear presupuestos por categoría
- Monitoreo de gasto vs presupuesto
- Alertas de presupuesto excedido
- Visualización de progreso

### 4. **Plan de Ahorros**
- Crear metas de ahorro con fecha objetivo
- Seguimiento de progreso
- Múltiples metas simultáneas
- Notificaciones de completadas

### 5. **Sincronización Familiar**
- Sincronización en tiempo real con Firebase
- Base de datos local (SQLite) para modo offline
- Gestión de múltiples miembros familiares
- Compartir presupuestos familiares

## 🏗️ Arquitectura del Proyecto

```
lib/
├── main.dart                          # Punto de entrada
├── models/                            # Modelos de datos
│   ├── transaction.dart              # Modelo de transacciones
│   ├── category.dart                 # Modelo y utilidades de categorías
│   ├── budget.dart                   # Modelo de presupuestos
│   └── savings_goal.dart             # Modelo de objetivos de ahorro
├── services/                          # Servicios de backend
│   ├── database_service.dart         # SQLite local
│   └── sync_service.dart             # Firebase Firestore
├── providers/                         # Gestión de estado (Provider)
│   ├── transaction_provider.dart     # Lógica de transacciones
│   ├── budget_provider.dart          # Lógica de presupuestos
│   └── savings_provider.dart         # Lógica de ahorros
├── screens/                           # Pantallas de la app
│   ├── home_screen.dart              # Dashboard principal
│   ├── add_transaction_screen.dart   # Agregar transacción
│   ├── analytics_screen.dart         # Análisis y gráficos
│   ├── budgets_screen.dart           # Gestión de presupuestos
│   └── savings_screen.dart           # Plan de ahorros
├── widgets/                           # Componentes reutilizables
│   ├── balance_card.dart             # Tarjeta de saldo
│   ├── transaction_item.dart         # Item de transacción
│   └── category_selector.dart        # Selector de categorías
├── theme/                             # Temas y estilos
│   └── app_theme.dart                # Tema global de Material 3
└── utils/                             # Utilidades
    ├── constants.dart                # Constantes y colores
    ├── formatters.dart               # Formatos de moneda, fecha
    └── validators.dart               # Validaciones
```

## 🔄 Flujo de Datos

```
┌─────────────────────────────────────────────────────────────┐
│                      UI Screens                             │
│  (Home, Analytics, Budgets, Savings)                       │
└──────────────┬──────────────────────────────────────────────┘
               │
               │ consume/watch
               ▼
┌─────────────────────────────────────────────────────────────┐
│               State Management (Provider)                   │
│  (TransactionProvider, BudgetProvider, SavingsProvider)    │
└──────────────┬──────────────────────────────────────────────┘
               │
               │ notifyListeners()
               ▼
┌─────────────────────────────────────────────────────────────┐
│                     Services Layer                          │
│  ┌──────────────────┐         ┌──────────────────┐         │
│  │ DatabaseService  │         │  SyncService     │         │
│  │ (SQLite Local)   │         │ (Firebase)       │         │
│  └──────────────────┘         └──────────────────┘         │
└──────────────┬──────────────────────────────────────────────┘
               │
               │
        ┌──────┴──────┐
        ▼             ▼
   ┌─────────┐   ┌──────────┐
   │ SQLite  │   │ Firestore│
   │  (DB)   │   │   (Cloud)│
   └─────────┘   └──────────┘
```

## 📦 Dependencias Principales

```yaml
dependencies:
  flutter: sdk: flutter
  provider: ^6.0.0              # Gestión de estado
  sqflite: ^2.3.0               # Base de datos local
  path: ^1.8.3                  # Rutas de archivos
  intl: ^0.19.0                 # Internacionalización
  fl_chart: ^0.65.0             # Gráficos
  firebase_core: ^2.24.0        # Firebase base
  cloud_firestore: ^4.13.0      # Firestore
  firebase_auth: ^4.15.0        # Autenticación
  google_sign_in: ^6.1.5        # Sign in con Google
  shared_preferences: ^2.2.2    # Preferencias locales
  uuid: ^4.0.0                  # Generar IDs únicos
  connectivity_plus: ^5.0.0     # Detectar conexión
```

## 🚀 Cómo Usar

### 1. **Instalación de Dependencias**
```bash
flutter pub get
```

### 2. **Configurar Firebase** (Opcional para sincronización)
```bash
flutterfire configure
```

### 3. **Ejecutar la App**
```bash
flutter run
```

## 🎨 Diseño y UX

### Paleta de Colores
- **Primario**: `#432267` (Púrpura)
- **Secundario**: `#5862D5` (Azul)
- **Acento**: `#1ABC9C` (Verde Turquesa)
- **Success**: `#27AE60` (Verde)
- **Error**: `#E74C3C` (Rojo)

### Características de Diseño
- ✅ Material Design 3
- ✅ Interfaz moderna y limpia
- ✅ Modo offline con sincronización
- ✅ Gráficos interactivos
- ✅ Animaciones suaves
- ✅ Responsive (móvil)

## 📋 Modelos de Datos

### Transaction
```dart
class Transaction {
  String id;
  String description;
  double amount;
  TransactionType type;      // income / expense
  String category;
  DateTime date;
  String userId;
  String? notes;
  bool isRecurring;
}
```

### Budget
```dart
class Budget {
  String id;
  String category;
  double limit;
  double spent;
  int month;
  int year;
  String userId;
}
```

### SavingsGoal
```dart
class SavingsGoal {
  String id;
  String title;
  String description;
  double targetAmount;
  double currentAmount;
  DateTime targetDate;
  String userId;
  bool isCompleted;
}
```

## 🔐 Seguridad

- Datos sensibles almacenados localmente en SQLite
- Sincronización cifrada con Firestore
- Autenticación con Firebase Auth
- Isolación de datos por usuario

## 🌐 Modos de Operación

### Modo Online
- Sincronización automática con Firestore
- Datos compartidos entre dispositivos
- Actualización en tiempo real

### Modo Offline
- Operación completamente local
- Datos guardados en SQLite
- Sincronización cuando hay conexión

## 📱 Pantallas

### 1. Home Screen
- Dashboard principal
- Tarjeta de saldo total
- Últimas transacciones (5)
- Alertas de presupuesto

### 2. Analytics Screen
- Gráfico de pastel de gastos
- Desglose por categoría
- Navegación por meses
- Estadísticas mensuales

### 3. Budgets Screen
- Lista de presupuestos
- Progreso visual
- Crear/editar presupuestos
- Alertas de exceso

### 4. Savings Screen
- Plan de ahorros
- Metas activas y completadas
- Agregar dinero a metas
- Seguimiento de progreso

## 🔄 Flujo de Transacciones

```
1. Usuario abre "Agregar Transacción"
   ↓
2. Selecciona Ingreso/Egreso
   ↓
3. Ingresa monto y descripción
   ↓
4. Selecciona categoría
   ↓
5. Selecciona fecha
   ↓
6. Guarda localmente en SQLite
   ↓
7. Se sincroniza con Firebase
   ↓
8. Se actualiza presupuesto asociado
   ↓
9. Se recalculan gráficos y análisis
```

## 🎯 Próximas Mejoras

- [ ] Autenticación completa (Login/Register)
- [ ] Sincronización de múltiples usuarios familiares
- [ ] Notificaciones push
- [ ] Exportar reportes (PDF/CSV)
- [ ] Análisis predictivo
- [ ] Modo oscuro
- [ ] Multi-idioma (es/en)
- [ ] Validación de transacciones recurrentes
- [ ] Categorías personalizadas
- [ ] Integración con bancos

## 📞 Soporte

Para reportar bugs o sugerencias, contacta al desarrollador.

---

**Desarrollado con ❤️ usando Flutter**
