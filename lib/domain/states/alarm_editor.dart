import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rapido_reminder/domain/entities/alarm.dart';
import 'package:rapido_reminder/domain/states/alarm_manager.dart';
import 'package:rapido_reminder/utils/utils.dart';

class AlarmEditor extends GetxController {
  final title = ' '.obs;
  DateTime _date = DateTime.now();
  final dateStr = DateFormat('y-MM-dd').format(DateTime.now()).obs;
  final timeStr = DateFormat('HH:mm').format(DateTime.now()).obs;
  final duration = const Duration(minutes: 0).obs;
  final isOpen = false.obs;

  set alarmDate(DateTime val) {
    _date = val;
    dateStr.value = DateFormat('y-MM-dd').format(val);
    timeStr.value = DateFormat('HH:mm').format(val);
    final range = DateTimeRange(start: DateTime.now(), end: alarmDate);
    duration.value = roundToMinutes(range.duration);
  }

  DateTime get alarmDate => _date;

  String get durationStr => duration.value.inMinutes.toString();

  openEditor({Alarm? alarm
  }) {
    if (alarm != null) {
      title.value = alarm.title;
      setDuration(alarm.duration.inMinutes);
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
    final alarm =
        Alarm(title: title.value, date: _date, duration: duration.value);
    Get.find<AlarmsManager>().createAlarm(alarm: alarm);
    isOpen.value = false;
  }
}
