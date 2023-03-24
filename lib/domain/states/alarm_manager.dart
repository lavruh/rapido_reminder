import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'package:rapido_reminder/domain/entities/alarm.dart';

class AlarmsManager extends GetxController {
  final alarms = <Alarm>[].obs;
  final inactiveAlarms = <Alarm>[].obs;

  getAlarms() async {
    final list = await AwesomeNotifications().listScheduledNotifications();
    alarms.value = list.map((e) => Alarm.fromNotificationModel(e)).toList();
  }

  createAlarm({
    required Alarm alarm,
  }) async {
    await AwesomeNotifications().cancel(alarm.id);

    await AwesomeNotifications().createNotification(
      content: alarm.toNotificationContent(),
      schedule: alarm.toNotificationCalendar(),
    );
    alarms.add(alarm);
  }

  moveAlarmToInactive(int id){
    final index = alarms.indexWhere((e) => e.id == id);
    final alarm = alarms.removeAt(index);
    inactiveAlarms.add(alarm);
  }
}
