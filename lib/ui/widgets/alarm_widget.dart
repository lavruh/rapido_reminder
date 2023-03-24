import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rapido_reminder/domain/entities/alarm.dart';

class AlarmWidget extends StatelessWidget {
  const AlarmWidget({Key? key, required this.item, this.inActive = false})
      : super(key: key);
  final Alarm item;
  final bool inActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          elevation: 5,
          child: ListTile(
            tileColor: inActive ? Colors.grey : null,
            leading: inActive
                ? const Icon(Icons.alarm_off)
                : const Icon(Icons.alarm),
            title: Text( inActive ?
              "${item.title} = ${item.duration}" :
              "${item.title} @ ${DateFormat('y-MM-dd HH:mm').format(item.date)}",
            ),
          )),
    );
  }
}
