import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
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
