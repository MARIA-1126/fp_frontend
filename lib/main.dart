import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';  // Add this

import 'models/task_models.dart';
import 'providers/task_provider.dart';  // Add this
import 'screens/home_screen.dart';
import 'services/notification_service.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(QuadrantTypeAdapter());
  await Hive.openBox<TaskModel>('tasksBox');
  
  // Initialize notifications
  await NotificationService().initialize();
  
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
    return MultiProvider(  // Use MultiProvider
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}