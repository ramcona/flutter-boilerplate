import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// ---------------------------------------------------------------------------
// NOTIFICATION SERVICE
// ---------------------------------------------------------------------------
// Singleton service for local notification scheduling.
// Call initialize() in main() and reRegisterAll() on every app boot.
// ---------------------------------------------------------------------------

class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  /// Initialize local notification plugin and timezone database.
  static Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
    _initialized = true;
  }

  /// Request notification permissions (Android 13+ and iOS).
  static Future<bool?> requestPermissions() async {
    final androidImpl = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl != null) {
      await androidImpl.requestNotificationsPermission();
    }

    final iosImpl = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (iosImpl != null) {
      return iosImpl.requestPermissions(alert: true, badge: true, sound: true);
    }
    return true;
  }

  /// Schedule a daily reminder at the given hour:minute (local time).
  static Future<void> scheduleDailyReminder({
    int id = 0,
    int hour = 18,
    int minute = 0,
    String title = 'Daily Reminder',
    String body = "Don't forget to check in!",
    String channelId = 'daily_reminder_channel',
    String channelName = 'Daily Reminders',
  }) async {
    await initialize();

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final notifDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notifDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Cancel a specific scheduled notification by its ID.
  static Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancel all scheduled notifications.
  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  /// Re-register all notifications on app boot.
  /// Call this in main() to survive OS-level data clears.
  static Future<void> reRegisterAll() async {
    await initialize();
    await scheduleDailyReminder();
  }
}
