import 'package:flutter/material.dart';

class AppColors {
  // Colores primarios
  static const Color primaryColor = Color(0xFF432267); // Púrpura oscuro
  static const Color secondaryColor = Color(0xFF5862D5); // Azul
  static const Color accentColor = Color(0xFF1ABC9C); // Verde turquesa
  
  // Colores de estado
  static const Color successColor = Color(0xFF27AE60);
  static const Color warningColor = Color(0xFFF39C12);
  static const Color errorColor = Color(0xFFE74C3C);
  static const Color infoColor = Color(0xFF3498DB);
  
  // Colores neutros
  static const Color backgroundColor = Color(0xFFF8F9FE);
  static const Color surfaceColor = Colors.white;
  static const Color textColor = Color(0xFF2C3E50);
  static const Color textSecondaryColor = Color(0xFF95A5A6);
  
  // Colores de categorías
  static const Map<String, Color> categoryColors = {
    'food': Color(0xFFE67E22),
    'transport': Color(0xFF3498DB),
    'utilities': Color(0xFF27AE60),
    'entertainment': Color(0xFF9B59B6),
    'health': Color(0xFFE74C3C),
    'education': Color(0xFF5862D5),
    'shopping': Color(0xFFE91E63),
  };
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

class AppBorderRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 999.0;
}

class AppShadows {
  static const BoxShadow light = BoxShadow(
    color: Color(0x1F000000),
    blurRadius: 4,
    offset: Offset(0, 2),
  );

  static const BoxShadow medium = BoxShadow(
    color: Color(0x24000000),
    blurRadius: 8,
    offset: Offset(0, 4),
  );

  static const BoxShadow heavy = BoxShadow(
    color: Color(0x33000000),
    blurRadius: 16,
    offset: Offset(0, 8),
  );
}
