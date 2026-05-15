import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeChanged,
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _notificationsEnabled;

  @override
  void initState() {
    super.initState();
    _notificationsEnabled = widget.notificationsEnabled;
  }

  @override
  Widget build(BuildContext context) {
    // Get pending task count from provider
    final taskProvider = Provider.of<TaskProvider>(context);
    final pendingCount = taskProvider.getPendingTaskCount();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          // Theme Toggle
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Switch between light and dark theme'),
            value: widget.isDarkMode,
            onChanged: widget.onDarkModeChanged,
          ),
          
          // Notifications Toggle
          SwitchListTile(
            title: const Text('Enable Notifications'),
            subtitle: const Text('Receive daily reminders at 7 PM and 9 AM'),
            value: _notificationsEnabled,
            onChanged: (value) async {
              setState(() {
                _notificationsEnabled = value;
              });
              widget.onNotificationsChanged(value);
              
              if (value) {
                // Schedule notifications with the current pending count
                await NotificationService().scheduleEveningReminder(pendingCount);
                await NotificationService().scheduleMorningReminder();
              } else {
                // Cancel all notifications
                await NotificationService().cancelAllNotifications();
              }
            },
          ),
          
          const Divider(),
          
          // Notification times info
          ListTile(
            leading: const Icon(Icons.notifications_active),
            title: const Text('Reminder Times'),
            subtitle: const Text('Morning: 9:00 AM | Evening: 7:00 PM'),
          ),
          
          // Show pending tasks count
          ListTile(
            leading: const Icon(Icons.task_alt),
            title: const Text('Pending Tasks'),
            subtitle: Text('$pendingCount tasks pending completion'),
          ),
        ],
      ),
    );
  }
}