import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'package:rapido_reminder/data/i_store_serv.dart';
import 'package:rapido_reminder/domain/entities/alarm.dart';

class AlarmsManager extends GetxController {
  final alarms = <Alarm>[].obs;
  final inactiveAlarms = <Alarm>[].obs;
  final _db = Get.find<IStoreServ>();

  getAlarms() async {
    final list = await AwesomeNotifications().listScheduledNotifications();
    alarms.value = list.map((e) => Alarm.fromNotificationModel(e)).toList();
    inactiveAlarms.clear();
    await for (final map in _db.readAll()) {
      inactiveAlarms.add(Alarm.fromMap(map));
    }
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
    final index = inactiveAlarms.indexWhere((e) => e.id == alarm.id);
    if (index != -1) {
      inactiveAlarms.removeAt(index);
    }
  }

  moveAlarmToInactive(int id) {
    final index = alarms.indexWhere((e) => e.id == id);
    final alarm = alarms.removeAt(index);
    updateInactiveAlarms(alarm);
    _db.create(alarm.toMap());
  }

  updateInactiveAlarms(Alarm alarm) {
    final index = inactiveAlarms.indexWhere((e) => e.id == alarm.id);
    if (index == -1) {
      inactiveAlarms.add(alarm);
    } else {
      inactiveAlarms.removeAt(index);
      inactiveAlarms.insert(index, alarm);
    }
  }

  cancelAlarm(Alarm alarm) async {
    await AwesomeNotifications().cancel(alarm.id);
    moveAlarmToInactive(alarm.id);
  }

  deleteInactiveAlarm(Alarm alarm) {
    final index = inactiveAlarms.indexWhere((e) => e.id == alarm.id);
    if (index != -1) {
      inactiveAlarms.removeAt(index);
      _db.delete(alarm.id.toString());
    }
  }
}
