import 'package:awesome_notifications/awesome_notifications.dart';

DateTime scheduleToDate(NotificationSchedule sch) {
  final map = sch.toMap();
  return DateTime(
      map['year'], map['month'], map['day'], map['hour'], map['minute']);
}

Duration roundToMinutes(Duration val){
  final ms = val.inMilliseconds;
  if(ms % 60000 == 0){
    return val;
  }
  final tmp = ms / 60000;
  return Duration(minutes: tmp.round());
}