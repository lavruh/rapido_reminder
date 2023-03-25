import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:rapido_reminder/domain/entities/alarm.dart';

class AlarmWidget extends StatelessWidget {
  const AlarmWidget(
      {Key? key,
      required this.item,
      this.inActive = false,
      this.onTap,
      this.onSlideTap,
      required this.slideIcon})
      : super(key: key);
  final Alarm item;
  final bool inActive;
  final void Function()? onTap;
  final IconData slideIcon;
  final void Function()? onSlideTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Slidable(
        endActionPane: ActionPane(motion: const ScrollMotion(), children: [
          SlidableAction(
            icon: slideIcon,
            onPressed: (_) {
              if( onSlideTap != null) {
                onSlideTap!();
              }
            },
          )
        ]),
        child: Card(
          elevation: 5,
          child: ListTile(
            tileColor: inActive ? Colors.grey.shade200 : null,
            leading: inActive
                ? const Icon(Icons.alarm_off)
                : const Icon(Icons.alarm),
            title: Text(
              inActive
                  ? "${item.title} in ${item.duration.inMinutes} min."
                  : "${item.title} @ ${DateFormat('y-MM-dd HH:mm').format(item.date)}",
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
