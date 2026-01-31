import 'package:flutter/material.dart';
import 'app_colors.dart';

ThemeData buildAppTheme() {
  return ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(primary: AppColors.primary),
    textTheme: const TextTheme(
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  );
}
