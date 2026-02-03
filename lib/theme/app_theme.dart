import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F8FF),
      inputDecorationTheme: _inputTheme(),
      floatingActionButtonTheme: _fabTheme(),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.black,
      inputDecorationTheme: _inputTheme(),
      floatingActionButtonTheme: _fabTheme(),
    );
  }

  static InputDecorationTheme _inputTheme() {
    return InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  static FloatingActionButtonThemeData _fabTheme() {
    return const FloatingActionButtonThemeData(
      shape: CircleBorder(),
    );
  }
}
