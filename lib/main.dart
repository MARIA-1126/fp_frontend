import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'themes/app_theme.dart';

void main() {
  runApp(const EisenhowerApp());
}

class EisenhowerApp extends StatefulWidget {
  const EisenhowerApp({super.key});

  @override
  State<EisenhowerApp> createState() => _EisenhowerAppState();
}

class _EisenhowerAppState extends State<EisenhowerApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eisenhower Matrix Task Manager',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        isDarkMode: _isDarkMode,
        onToggleDarkMode: (v) {
          setState(() => _isDarkMode = v);
        },
      ),
    );
  }
}
