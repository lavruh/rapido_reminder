import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'package:rapido_reminder/data/i_store_serv.dart';
import 'package:rapido_reminder/domain/entities/alarm.dart';
import 'package:rapido_reminder/utils/bool_ext.dart';

class AlarmsManager extends GetxController {
  final alarms = <Alarm>[].obs;
  final _db = Get.find<IStoreServ>();

  getAlarms() async {
    final list = await AwesomeNotifications().listScheduledNotifications();
    final activeAlarms =
        list.map<Alarm>((e) => Alarm.fromNotificationModel(e)).toList();
    alarms.clear();
    await for (final map in _db.readAll()) {
      Alarm a = Alarm.fromMap(map);
      final isActive =
          activeAlarms.firstWhereOrNull((element) => element.id == a.id);
      if (isActive != null) {
        a = a.copyWith(isActive: true);
      }
      alarms.add(a);
    }
    alarms.sort((a, b) => a.isActive.compareTo(b.isActive));
  }

  createAlarm({
    required Alarm alarm,
  }) async {
    final newAlarm = alarm.copyWith(isActive: true);
    await AwesomeNotifications().cancel(newAlarm.id);
    await AwesomeNotifications().createNotification(
      content: newAlarm.toNotificationContent(),
      schedule: newAlarm.toNotificationCalendar(),
      actionButtons: [
        NotificationActionButton(key: "5", label: 'Postpone 5min'),
        NotificationActionButton(key: "30", label: 'Postpone 30min'),
      ],
    );
    updateAlarm(newAlarm);

    _db.create(alarm.toMap());
  }

  moveAlarmToInactive(int id) {
    final index = alarms.indexWhere((e) => e.id == id);
    final alarm = alarms.removeAt(index);
    alarms.insert(index, alarm.copyWith(isActive: false));
  }

  updateAlarm(Alarm alarm) {
    final index = alarms.indexWhere((e) => e.id == alarm.id);
    if (index == -1) {
      alarms.add(alarm);
    } else {
      alarms.removeAt(index);
      alarms.insert(0, alarm);
    }
    alarms.value = [...alarms];
  }

  cancelAlarm(Alarm alarm) async {
    await AwesomeNotifications().cancel(alarm.id);
    updateAlarm(alarm.copyWith(isActive: false));
  }

  deleteInactiveAlarm(Alarm alarm) {
    final index = alarms.indexWhere((e) => e.id == alarm.id);
    if (index != -1) {
      alarms.removeAt(index);
      _db.delete(alarm.id.toString());
    }
  }

  postponeAlarm({
    required int id,
    required int postponeMinutes,
  }) {
    final alarm = alarms.firstWhereOrNull((e) => e.id == id);
    if (alarm == null) {
      Get.snackbar('Error', "Alarm not found");
      return;
    }
    final now = DateTime.now();
    final d = Duration(minutes: postponeMinutes);
    final newDate = DateTime.fromMillisecondsSinceEpoch(
        now.millisecondsSinceEpoch + d.inMilliseconds);
    createAlarm(alarm: alarm.copyWith(date: newDate));
  }
}
