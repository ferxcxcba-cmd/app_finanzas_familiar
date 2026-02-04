import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    // Continuar sin Firebase (modo offline)
  }
  
  runApp(const FinanzasFamiliarApp());
}

class FinanzasFamiliarApp extends StatelessWidget {
  const FinanzasFamiliarApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finanzas Familiar',
      theme: AppTheme.lightTheme(),
      home: const HomeScreen(userId: 'user123'), // Cambiar por auth real
      debugShowCheckedModeBanner: false,
    );
  }
}
