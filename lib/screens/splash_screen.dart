import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
    });

  final bool isDarkMode;
  final ValueChanged<bool> onToggleDarkMode;
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadApp();
    });
  }

  Future<void> _loadApp() async {
    // Load tasks from Hive
    await Provider.of<TaskProvider>(context, listen: false).loadTasks();

    // Wait for Lottie animation to complete (approx 3 seconds)
    await Future.delayed(const Duration(seconds: 3));

    // Navigate to Home Screen
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            // Remove 'const'
            isDarkMode: false,
            onToggleDarkMode: (v) {},
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/splash_animation.json',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Text(
              'Priority Matrix',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
