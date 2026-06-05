import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'logging_service.dart';

class NotificationService {
  final Ref _ref;
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationService(this._ref);

  // Initialize Notifications
  Future<void> init() async {
    final log = _ref.read(loggerProvider);
    log.i("Initializing NotificationService...");
    
    // Timezone Database Initialization (required for scheduling)
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          log.i("Notification clicked! Payload: ${response.payload}");
        },
      );
      log.i("NotificationService initialized successfully.");
    } catch (e, stack) {
      log.e("Error initializing NotificationService", e, stack);
    }
  }

  // Request Permissions
  Future<bool> requestPermissions() async {
    final log = _ref.read(loggerProvider);
    log.i("Requesting notification permissions...");
    try {
      final androidPlatform = _notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlatform != null) {
        final granted = await androidPlatform.requestNotificationsPermission();
        log.i("Android notification permission status: $granted");
        return granted ?? false;
      }
      
      final iosPlatform = _notificationsPlugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (iosPlatform != null) {
        final granted = await iosPlatform.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        log.i("iOS notification permission status: $granted");
        return granted ?? false;
      }
      return false;
    } catch (e, stack) {
      log.e("Error requesting notification permissions", e, stack);
      return false;
    }
  }

  // Schedule Repeating Daily Notification (e.g. at 8:00 PM)
  Future<void> scheduleDailyReminder() async {
    final log = _ref.read(loggerProvider);
    final hasPermission = await requestPermissions();
    if (!hasPermission) {
      log.w("Failed to schedule daily reminder: Permission denied.");
      return;
    }

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_reminder_channel',
      'Daily Reminders',
      channelDescription: 'Scheduled daily reading reminder for BookVista users.',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    try {
      // Cancel previous reminder if exists to avoid duplication
      await cancelDailyReminder();

      log.i("Scheduling daily reminder for 8:00 PM...");
      
      // Calculate 8:00 PM timezone aware
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        20, // 8 PM (Hour)
        0,  // Minute
      );

      // If scheduled time has already passed today, schedule for tomorrow
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _notificationsPlugin.zonedSchedule(
        1001, // Notification ID
        'Time to settle in! 📖',
        'Your quiet sanctuary is waiting. Open BookVista and read a chapter.',
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, // Repeat daily at this exact time
      );
      log.i("Daily reminder scheduled successfully for: $scheduledDate");
    } catch (e, stack) {
      log.e("Error scheduling daily reminder", e, stack);
    }
  }

  // Cancel Daily Reminder
  Future<void> cancelDailyReminder() async {
    final log = _ref.read(loggerProvider);
    try {
      log.i("Cancelling daily reminder notification (ID 1001)...");
      await _notificationsPlugin.cancel(1001);
      log.i("Daily reminder cancelled.");
    } catch (e, stack) {
      log.e("Error cancelling daily reminder", e, stack);
    }
  }
}

// Provider for NotificationService
final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService(ref));
