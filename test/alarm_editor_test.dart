import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:rapido_reminder/domain/states/alarm_editor.dart';

main() {
  final sut = AlarmEditor();

  test('select date', () async {
    final now = DateTime.now();
    final time = TimeOfDay(hour: now.hour - 1, minute: now.minute);
    final newDate =
        now.copyWith(day: now.day + 7, hour: time.hour, minute: time.minute);

    sut.pickupDateTime(date: newDate, rawTimeVal: time);

    expect(sut.alarmDate.year, now.year);
    expect(sut.alarmDate.month, now.month);
    expect(sut.alarmDate.day, now.day + 7);
    expect(sut.alarmDate.hour, time.hour);
    expect(sut.alarmDate.minute, time.minute);
    expect(sut.dateStr.value, DateFormat('y-MM-dd').format(newDate));
    expect(sut.timeStr.value, DateFormat('HH:mm').format(newDate));
  });

  test('select time ahead', () async {
    final now = DateTime.now();
    final time = TimeOfDay(hour: now.hour + 1, minute: now.minute - 3);

    sut.pickupDateTime(rawTimeVal: time);

    final duration = DateTimeRange(
        start: now, end: now.copyWith(hour: time.hour, minute: time.minute));

    expect(sut.alarmDate.year, now.year);
    expect(sut.alarmDate.month, now.month);
    expect(sut.alarmDate.day, now.day);
    expect(sut.alarmDate.hour, time.hour);
    expect(sut.alarmDate.minute, time.minute);
    expect(sut.dateStr.value, DateFormat('y-MM-dd').format(now));
    expect(
        sut.timeStr.value,
        DateFormat('HH:mm')
            .format(now.copyWith(hour: time.hour, minute: time.minute)));
    expect(sut.durationStr.value, duration.duration.inMinutes.toString());
  });

  test('select time at tomorrow', () async {
    final now = DateTime.now();
    final time = TimeOfDay(hour: now.hour - 1, minute: now.minute);
    final tommorow =
        now.copyWith(day: now.day + 1, hour: time.hour, minute: time.minute);

    sut.pickupDateTime(rawTimeVal: time);

    expect(sut.alarmDate.year, now.year);
    expect(sut.alarmDate.month, now.month);
    expect(sut.alarmDate.day, now.day + 1);
    expect(sut.alarmDate.hour, time.hour);
    expect(sut.alarmDate.minute, time.minute);
    expect(sut.dateStr.value, DateFormat('y-MM-dd').format(tommorow));
    expect(sut.timeStr.value, DateFormat('HH:mm').format(tommorow));
  });

  test('select duration', () async {
    final now = DateTime.now();
    final time = TimeOfDay(hour: now.hour - 1, minute: now.minute);
    final tommorow =
        now.copyWith(day: now.day + 5, hour: time.hour, minute: time.minute);
    final duration = DateTimeRange(start: now, end: tommorow).duration.inMinutes;

    sut.setDuration(duration);

    expect(sut.alarmDate.year, now.year);
    expect(sut.alarmDate.month, now.month);
    expect(sut.alarmDate.day, now.day + 5);
    expect(sut.alarmDate.hour, time.hour);
    expect(sut.alarmDate.minute, time.minute);
    expect(sut.dateStr.value, DateFormat('y-MM-dd').format(tommorow));
    expect(sut.timeStr.value, DateFormat('HH:mm').format(tommorow));
  });
}
