import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rapido_reminder/utils/utils.dart';

class AlarmWidget extends StatelessWidget {
  const AlarmWidget({Key? key, required this.item}) : super(key: key);
  final NotificationModel item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          elevation: 5,
          child: ListTile(
            leading: const Icon(Icons.alarm),
            title: Text(
                "${item.content?.title} @ ${_getScheduleDateTime(item.schedule)}"),
          )),
    );
  }

  String _getScheduleDateTime(NotificationSchedule? sch) {
    if (sch != null) {
      try {
        return DateFormat('y-MM-dd HH:mm').format(scheduleToDate(sch));
      } on Exception catch(e){
        Get.snackbar('Error', 'Wrong notification date [$e]');
      }
    }
    return "";
  }
}
