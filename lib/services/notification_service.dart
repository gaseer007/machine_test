import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await _notifications.initialize(initializationSettings);

    // 👇 Add this: create the channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'booking_channel', // id
      'Booking Notifications', // name
      description: 'Notifications for booking updates',
      importance: Importance.high,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    await _notifications.initialize(initializationSettings);
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'booking_channel',
          'Booking Notifications',
          channelDescription: 'Notifications for booking updates',
          importance: Importance.high,
          priority: Priority.high,
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notifications.show(id, title, body, platformChannelSpecifics);
  }

  static void startBookingReminder() {
    final List<String> messages = [
      'Booking is waiting! Come and book Innerspace now.',
      'A new desk is available. Book your slot today!',
      'Innerspace welcomes you! Book your co-working space now.',
    ];
    int index = 0;

    Timer.periodic(const Duration(minutes: 1), (timer) {
      showNotification(
        id: 0,
        title: 'Innerspace',
        body: messages[index % messages.length],
      );
      index++;
    });
  }
}
