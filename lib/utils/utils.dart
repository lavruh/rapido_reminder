import 'package:awesome_notifications/awesome_notifications.dart';

DateTime scheduleToDate(NotificationSchedule sch) {
  final map = sch.toMap();
  return DateTime(
      map['year'], map['month'], map['day'], map['hour'], map['minute']);
}
