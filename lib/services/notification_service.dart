// lib/services/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// NotificationService
/// - Menyediakan method inisialisasi dan showNotification yang memunculkan
///   system notification (bukan SnackBar)
class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  /// Panggil ini sekali di main() sebelum runApp()
  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: iOS),
    );
  }

  /// Tampilkan notifikasi sederhana
  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'paruguard_channel',
      'ParuGuard Alerts',
      channelDescription: 'Peringatan kualitas udara ParuGuard',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iOSDetails = DarwinNotificationDetails();
    await _plugin.show(
      0,
      title,
      body,
      const NotificationDetails(android: androidDetails, iOS: iOSDetails),
    );
  }
}
