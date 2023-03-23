import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rapido_reminder/domain/states/alarm_manager.dart';
import 'package:rapido_reminder/utils/utils.dart';

class AlarmEditor extends GetxController {
  final title = 'alarm'.obs;
  DateTime _date = DateTime.now();
  final dateStr = DateFormat('y-MM-dd').format(DateTime.now()).obs;
  final timeStr = DateFormat('HH:mm').format(DateTime.now()).obs;
  final durationStr = '0'.obs;
  final isOpen = false.obs;

  set alarmDate(DateTime val) {
    _date = val;
    dateStr.value = DateFormat('y-MM-dd').format(val);
    timeStr.value = DateFormat('HH:mm').format(val);
    final range = DateTimeRange(start: DateTime.now(), end: alarmDate);
    durationStr.value = range.duration.inMinutes.toString();
  }

  DateTime get alarmDate => _date;

  openEditor({
    NotificationContent? content,
    NotificationCalendar? schedule,
  }) {
    if (content != null && schedule != null) {
      title.value = content.title ?? 'alarm';
      alarmDate = scheduleToDate(schedule);
    }
    isOpen.value = true;
  }

  pickupDateTime({DateTime? date, TimeOfDay? rawTimeVal}) async {
    if (rawTimeVal != null) {
      final now = DateTime.now();
      final rawDateVal =
          now.copyWith(hour: rawTimeVal.hour, minute: rawTimeVal.minute);
      final tomorrow = DateTime.fromMillisecondsSinceEpoch(
          now.millisecondsSinceEpoch + const Duration(days: 1).inMilliseconds);
      final timeVal = rawDateVal.millisecondsSinceEpoch >=
              now.millisecondsSinceEpoch
          ? rawDateVal
          : tomorrow.copyWith(hour: rawTimeVal.hour, minute: rawTimeVal.minute);
      alarmDate =
          date?.copyWith(hour: rawTimeVal.hour, minute: rawTimeVal.minute) ??
              timeVal;
    }
  }

  setDuration(int duration) {
    final now = DateTime.now();
    final d = Duration(minutes: duration);
    final newDate = DateTime.fromMillisecondsSinceEpoch(
        now.millisecondsSinceEpoch + d.inMilliseconds);
    alarmDate = newDate;
  }

  submit() async {
    NotificationContent content = NotificationContent(
      id: DateTime.now().second + DateTime.now().millisecond,
      title: title.value,
      channelKey: 'alarm_channel',
      showWhen: true,
      wakeUpScreen: true,
      category: NotificationCategory.Reminder,
      actionType: ActionType.DismissAction,
    );

    NotificationCalendar schedule = NotificationCalendar(
      year: _date.year,
      month: _date.month,
      day: _date.day,
      hour: _date.hour,
      minute: _date.minute,
      allowWhileIdle: true,
      preciseAlarm: true,
    );
    Get.find<AlarmsManager>().createAlarm(content: content, schedule: schedule);
    isOpen.value = false;
  }
}
