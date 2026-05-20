import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xFF070B11),

    primaryColor: const Color(0xFFD4AF37),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFD4AF37),
      secondary: Color(0xFF89C2FF),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Color(0xFFF5E6A8),
        fontWeight: FontWeight.bold,
        fontSize: 34,
      ),

      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),

      bodyMedium: TextStyle(
        color: Colors.white70,
        fontSize: 14,
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Color(0xFFF5E6A8),
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
