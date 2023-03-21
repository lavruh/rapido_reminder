import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AlarmEditor extends GetxController {
  final title = 'alarm'.obs;
  DateTime _date = DateTime.now();
  final dateStr = DateFormat('y-MM-dd').format(DateTime.now()).obs;
  final timeStr = DateFormat('HH:mm').format(DateTime.now()).obs;
  final durationStr = '0'.obs;

  set alarmDate(DateTime val) {
    _date = val;
    dateStr.value = DateFormat('y-MM-dd').format(val);
    timeStr.value = DateFormat('HH:mm').format(val);
  }

  DateTime get alarmDate => _date;

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
      final range = DateTimeRange(start: now, end: alarmDate);
      durationStr.value = range.duration.inMinutes.toString();
    }
  }

  setDuration(int duration) {
    final now = DateTime.now();
    final d = Duration(minutes: duration);
    final newDate = DateTime.fromMillisecondsSinceEpoch(
        now.millisecondsSinceEpoch + d.inMilliseconds);
    alarmDate = newDate;
    durationStr.value = duration.toString();
  }

  submit() async {
    NotificationContent content = NotificationContent(
      id: 0,
      title: title.value,
      channelKey: 'alarm_channel',
      criticalAlert: true,
      category: NotificationCategory.Alarm,
      actionType: ActionType.KeepOnTop,
    );

    NotificationCalendar schedule = NotificationCalendar(
      year: _date.year,
      month: _date.month,
      day: _date.day,
      hour: _date.hour,
      minute: _date.minute,
    );
    final success = await  AwesomeNotifications().createNotification(
        content: content,
        schedule: schedule,
      );
    if(!success){
      Get.snackbar('Error :', 'Can not create notification');
    }
  }
}
