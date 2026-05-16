import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'models/task_models.dart';
import 'providers/task_provider.dart';
import 'screens/home_screen.dart';
// import 'services/notification_service.dart';
import 'screens/splash_screen.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(QuadrantTypeAdapter());
  await Hive.openBox<TaskModel>('tasksBox');

  runApp(const EisenhowerApp());
}

class EisenhowerApp extends StatefulWidget {
  const EisenhowerApp({super.key});

  @override
  State<EisenhowerApp> createState() => _EisenhowerAppState();
}

class _EisenhowerAppState extends State<EisenhowerApp> {
  // ✅ Remove 'final' so it can be changed
  bool _isDarkMode = false;

  // ✅ Add this method to toggle dark mode
  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TaskProvider())],
      child: MaterialApp(
        title: 'Eisenhower Matrix Task Manager',
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        // ✅ Use HomeScreen directly with the toggle function
        home: SplashScreen(
          isDarkMode: _isDarkMode,
          onToggleDarkMode: _toggleDarkMode, // ✅ Pass the toggle method
        ),
      ),
    );
  }
}
