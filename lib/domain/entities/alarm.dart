import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:rapido_reminder/utils/utils.dart';

class Alarm {
  final int id;
  final String title;
  final DateTime date;
  final Duration duration;
  final bool isActive;

  Alarm({
    int? id,
    required this.title,
    required this.date,
    required this.duration,
    this.isActive = false,
  }) : id = id ?? generateId();

  Alarm copyWith({
    int? id,
    String? title,
    DateTime? date,
    Duration? duration,
    bool? isActive,
  }) {
    return Alarm(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      duration: duration ?? this.duration,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.millisecondsSinceEpoch,
      'duration': duration.inMilliseconds,
    };
  }

  factory Alarm.fromMap(Map<String, dynamic> map) {
    return Alarm(
      id: map['id'] as int,
      title: map['title'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      duration: Duration(milliseconds: map['duration']),
    );
  }

  factory Alarm.fromNotificationModel(NotificationModel e) {
    if (e.content == null || e.schedule == null) {
      throw Exception('Not valid notification $e');
    }
    return Alarm(
        id: e.content?.id,
        title: e.content?.title ?? '',
        date: scheduleToDate(e.schedule!),
        duration: Duration(minutes: e.content?.progress ?? 0),
        isActive: true);
  }

  NotificationContent toNotificationContent() {
    return NotificationContent(
      id: id,
      title: title,
      progress: duration.inMilliseconds,
      channelKey: 'alarm_channel',
      showWhen: true,
      wakeUpScreen: true,
      category: NotificationCategory.Reminder,
      actionType: ActionType.DismissAction,
    );
  }

  NotificationCalendar toNotificationCalendar() {
    return NotificationCalendar(
      year: date.year,
      month: date.month,
      day: date.day,
      hour: date.hour,
      minute: date.minute,
      allowWhileIdle: true,
      preciseAlarm: true,
    );
  }

  static int generateId() => DateTime.now().second + DateTime.now().millisecond;

  @override
  String toString() {
    return 'Alarm{id: $id, title: $title, date: $date, duration: $duration, isActive: $isActive} \n';
  }
}
