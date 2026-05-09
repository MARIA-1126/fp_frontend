import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      SwitchListTile(
                        value: isDarkMode,
                        onChanged: onDarkModeChanged,
                        secondary: const Icon(Icons.dark_mode_outlined),
                        title: const Text('Dark mode'),
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        value: notificationsEnabled,
                        onChanged: onNotificationsChanged,
                        secondary: const Icon(Icons.notifications_outlined),
                        title: const Text('Notifications'),
                        subtitle: const Text(
                          'UI-only toggle (no real notifications yet).',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        leading: Icon(Icons.info_outline),
                        title: Text('About'),
                        subtitle: Text(
                          'Eisenhower Matrix Task Manager (frontend UI demo).',
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        leading: const Icon(Icons.palette_outlined),
                        title: const Text('Design'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // UI-only. No navigation required.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'About section is UI-only for now.',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
