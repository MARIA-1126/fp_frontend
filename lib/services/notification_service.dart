/*import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();
  
  Future<void> initialize() async {
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosSettings = 
        DarwinInitializationSettings();
    
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(settings);
  }
  
  // 7 PM Reminder - Pending tasks count
  Future<void> scheduleEveningReminder(int pendingCount) async {
    final now = DateTime.now();
    final scheduledTime = DateTime(now.year, now.month, now.day, 19, 0); // 7 PM
    
    // If it's already past 7 PM, schedule for tomorrow
    final scheduledDate = now.isAfter(scheduledTime) 
        ? scheduledTime.add(const Duration(days: 1))
        : scheduledTime;
    
    await _notifications.zonedSchedule(
      1,
      'Evening Task Reminder',
      'You have $pendingCount pending tasks. Complete them before the day ends!',
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'evening_channel',
          'Evening Reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Replace deprecated param
    );
  }
  
  // Morning Reminder - Add tasks for the day
  Future<void> scheduleMorningReminder() async {
    final now = DateTime.now();
    final scheduledTime = DateTime(now.year, now.month, now.day, 9, 0); // 9 AM
    
    // If it's already past 9 AM, schedule for tomorrow
    final scheduledDate = now.isAfter(scheduledTime) 
        ? scheduledTime.add(const Duration(days: 1))
        : scheduledTime;
    
    await _notifications.zonedSchedule(
      2,
      'Morning Task Reminder',
      'Good morning! Plan your tasks for today using the Eisenhower Matrix.',
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'morning_channel',
          'Morning Reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Replace deprecated param
    );
  }
  
  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}*/