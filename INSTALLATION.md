# 🚀 GUÍA DE INSTALACIÓN Y SETUP

## ✅ PRE-REQUISITOS

### Windows (tu caso)
- [ ] **Flutter SDK** (v3.10.8+)
  - Descargar desde: https://flutter.dev/docs/get-started/install/windows
  - Agregar a PATH
  
- [ ] **Android Studio** (para emulador)
  - Descargar desde: https://developer.android.com/studio
  - Instalar SDK, emulador, etc.

- [ ] **Git** (control de versiones)
  - Descargar desde: https://git-scm.com

- [ ] **Visual Studio Code** (tu editor)
  - Ya tienes instalado ✅

### Verificar instalación
```bash
flutter --version
flutter doctor
```

---

## 📦 PASOS DE INSTALACIÓN

### 1. Clonar/Abrir proyecto
```bash
cd c:\Users\Dahyana\Desktop\code python\app_finanzas_familiar
```

### 2. Obtener dependencias
```bash
flutter pub get
```

Esto descargará todas las librerías del `pubspec.yaml`:
- ✅ provider (gestión estado)
- ✅ sqflite (base de datos)
- ✅ fl_chart (gráficos)
- ✅ firebase_core, cloud_firestore, firebase_auth
- ✅ Más 10+ dependencias

**Tiempo:** ~2-3 minutos (primera vez)

### 3. (OPCIONAL) Configurar Firebase

Si quieres sincronización en la nube:

```bash
# Instalar FlutterFire CLI
dart pub global activate flutterfire_cli

# Configurar Firebase para tu proyecto
flutterfire configure
```

Te pedirá:
- [ ] Seleccionar Google Cloud Project (o crear uno)
- [ ] Seleccionar plataformas (Android, iOS, Web)
- [ ] Descargar configuración

**Sin esto:** La app funciona 100% en modo offline con SQLite

### 4. Ejecutar la app

#### Opción A: En emulador Android
```bash
# Ver dispositivos disponibles
flutter devices

# Ejecutar
flutter run
```

#### Opción B: En dispositivo físico (Android)
```bash
# Conectar USB y habilitar "Depuración USB"
adb devices

# Ejecutar
flutter run
```

#### Opción C: Modo Hot Reload
```bash
flutter run
# En la consola, presiona 'r' para hot reload
```

---

## 🔧 TROUBLESHOOTING

### Problema: "Flutter not found"
```bash
# Solución: Agregar Flutter a PATH
# 1. Abre PowerShell como admin
# 2. $env:PATH += ";C:\path\to\flutter\bin"
```

### Problema: "No device connected"
```bash
# Para emulador:
flutter emulators

# Lanzar emulador:
flutter emulators --launch Pixel_4_API_30
```

### Problema: Dependencias sin resolver
```bash
flutter pub get --offline
flutter pub upgrade
flutter clean
flutter pub get
```

### Problema: "CocoaPods" (si corres en Mac/iOS)
```bash
cd ios
pod repo update
pod install
cd ..
```

### Problema: Firebase no sincroniza
```dart
// En main.dart, la inicialización es opcional:
try {
  await Firebase.initializeApp();
} catch (e) {
  debugPrint('Firebase init error: $e');
  // Continúa sin Firebase (offline mode)
}
```

---

## 📱 TESTEAR LA APP

### Test 1: Agregar una transacción
```
1. Abre app
2. Tap en + (FAB)
3. Selecciona "Egreso"
4. Ingresa: Monto=$50, Desc="Almuerzo", Cat="Food"
5. Selecciona fecha de hoy
6. Tap "Guardar"
✅ Debe aparecer en Home Screen
```

### Test 2: Ver gráficos
```
1. Tap "Análisis" en nav bar
2. Debe mostrar:
   - Mes actual
   - Ingresos y egresos
   - Pastel (PieChart)
   - Desglose por categoría
✅ Si no hay datos, está vacío pero sin errores
```

### Test 3: Crear presupuesto
```
1. Tap "Presupuestos"
2. Tap "Nuevo Presupuesto"
3. Selecciona "Alimentos"
4. Ingresa Límite=$300
5. Tap "Guardar"
✅ Debe aparecer en lista
```

### Test 4: Crear meta de ahorro
```
1. Tap "Ahorros"
2. Tap "Nueva Meta"
3. Título="Viaje", Monto=$2000, Fecha=90 días
4. Tap "Crear"
✅ Meta aparece con 0% progreso
```

### Test 5: Agregar dinero a meta
```
1. En "Ahorros"
2. Tap "Agregar Dinero" en una meta
3. Ingresa $200
4. Tap "Agregar"
✅ Progreso debe cambiar a 10%
```

---

## 📊 ESTRUCTURA DE CARPETAS DESPUÉS DEL SETUP

```
app_finanzas_familiar/
├── lib/                              ✅ Código fuente
│   ├── main.dart
│   ├── models/
│   ├── services/
│   ├── providers/
│   ├── screens/
│   ├── widgets/
│   ├── theme/
│   └── utils/
│
├── android/                          (Android native)
├── ios/                              (iOS native)
├── web/                              (Web)
├── windows/                          (Windows)
├── linux/                            (Linux)
├── macos/                            (macOS)
│
├── test/                             (Tests - no implementados)
│
├── pubspec.yaml                      ✅ Dependencias
├── pubspec.lock                      (Lock file - generado)
├── analysis_options.yaml             (Linting rules)
├── README.md
│
└── .dart_tool/                       (Generado - ignorar)
    .git/                             (Si es repo git)
```

---

## 🎯 PRÓXIMOS PASOS

### Inmediatos (Opcional)
- [ ] Inicializar GitHub repo
- [ ] Agregar Firebase (para sincronización)
- [ ] Agregar Google Sign-In (para auth)

### Corto Plazo
- [ ] Implementar pantalla de Login/Register
- [ ] Conectar Firebase Auth
- [ ] Agregar notificaciones

### Mediano Plazo
- [ ] Tests unitarios
- [ ] Tests de integración
- [ ] Documentación completa

### Largo Plazo
- [ ] Publicar en Google Play
- [ ] Publicar en App Store
- [ ] Agregar más features

---

## 📋 CHECKLIST DE VERIFICACIÓN

Después de ejecutar `flutter run`:

- [ ] App abre sin crashes
- [ ] Dashboard muestra "Sin transacciones aún"
- [ ] Botón (+) funciona
- [ ] Pantalla de agregar transacción abre
- [ ] Selector de categorías funciona
- [ ] DatePicker funciona
- [ ] Form valida correctamente
- [ ] Transacción se guarda
- [ ] Balance se actualiza
- [ ] Transacción aparece en lista
- [ ] Tab de Analytics funciona
- [ ] Tab de Presupuestos funciona
- [ ] Tab de Ahorros funciona
- [ ] Navegación entre tabs funciona
- [ ] Hot reload funciona (presiona 'r')
- [ ] Hot restart funciona (presiona 'R')

---

## 💾 BASES DE DATOS

### SQLite (Local)
```
Ubicación: Device file system
Base: finanzas_familiar.db

Tablas:
- transactions
- budgets
- savings_goals
```

**Ver datos SQLite:**
- Usar: DB Browser for SQLite
- O desde código: DebugPrint() en database_service.dart

### Firebase Firestore (Cloud)
```
Ubicación: Cloud console

Estructura:
users/{userId}/
  ├── transactions/{id}
  ├── budgets/{id}
  └── savings_goals/{id}

families/{code}/
  └── members/{email}
```

**Ver datos Firestore:**
- Firebase Console: https://console.firebase.google.com
- Pestña: Firestore Database

---

## 🔑 VARIABLES DE ENTORNO (Opcional)

Si quieres usar secrets (no recomendado para app local):

1. Crear `.env` file:
```
FIREBASE_PROJECT_ID=tu-proyecto-id
FIREBASE_API_KEY=tu-api-key
```

2. Instalar: `flutter_dotenv`

3. Usar en código:
```dart
String projectId = dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
```

---

## 🐛 MODO DEBUG

### Habilitar logs
En `constants.dart`:
```dart
const bool DEBUG_MODE = true;
```

En código:
```dart
if (DEBUG_MODE) {
  debugPrint('Debug: $variable');
}
```

### Ver errores en consola
```
flutter run -v  // Verbose mode
```

### Abrir DevTools
```
flutter pub global activate devtools
devtools
```

---

## 📱 BUILD PARA PRODUCCIÓN

### Android APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-app.apk
```

### Android App Bundle
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app.aab
```

### iOS IPA
```bash
flutter build ios --release
# Necesita Mac + Xcode
```

### Web
```bash
flutter build web
# Output: build/web/
```

---

## 📞 SOPORTE

Si encuentras problemas:

1. **Mensajes de error:**
   - Lee el mensaje completo en consola
   - Busca en Google: "Flutter [error message]"

2. **Dependencias rotas:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

3. **Cache corrupto:**
   ```bash
   flutter clean
   rm -r .dart_tool
   flutter pub get
   flutter run
   ```

4. **Versión Flutter:**
   ```bash
   flutter upgrade
   flutter downgrade  # Si necesitas versión específica
   ```

---

## ✅ INSTALACIÓN COMPLETADA

Si ves la app ejecutándose sin errores:

🎉 **¡FELICIDADES! Tu app de Finanzas Familiar está lista.**

### Próximos pasos:
1. Explora la UI
2. Agrega algunas transacciones
3. Crea presupuestos y metas
4. Personaliza colores/estilos si quieres
5. Considera agregarpago con Firebase (opcional)

---

**Última actualización:** 04/02/2026
**Versión Flutter mínima:** 3.10.8
**Versión Dart mínima:** 3.10.8
