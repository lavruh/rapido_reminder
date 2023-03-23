import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';

class AlarmsManager extends GetxController {
  final alarms = <NotificationModel>[].obs;
  AlarmsManager() {
    getAlarms();
  }

  getAlarms() async {
    alarms.value = await AwesomeNotifications().listScheduledNotifications();
  }

  createAlarm({
    required NotificationContent content,
    required NotificationSchedule schedule,
  }) async {
    await AwesomeNotifications().createNotification(
      content: content,
      schedule: schedule,
    );
    getAlarms();
  }
}
