import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapido_reminder/domain/states/alarm_editor.dart';
import 'package:rapido_reminder/domain/states/alarm_manager.dart';
import 'package:rapido_reminder/ui/widgets/alarm_editor_widget.dart';
import 'package:rapido_reminder/ui/widgets/alarm_widget.dart';

class AlarmsScreen extends StatelessWidget {
  const AlarmsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    Get.find<AlarmsManager>().getAlarms();
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            Get.find<AlarmsManager>().getAlarms();
          },
          child: GetX<AlarmsManager>(
            builder: (state) {
              return Column(
                children: [
                  Flexible(
                    child: ListView(
                      children: state.alarms
                          .map((e) => AlarmWidget(
                                item: e,
                                onTap: () {
                                  Get.find<AlarmEditor>().openEditor(alarm: e);
                                },
                                slideIcon: Icons.cancel,
                                onSlideTap: () => state.cancelAlarm(e),
                              ))
                          .toList(),
                    ),
                  ),
                  Flexible(
                    child: ListView(
                      children: state.inactiveAlarms
                          .map((e) => AlarmWidget(
                                item: e,
                                inActive: true,
                                onTap: () {
                                  Get.find<AlarmEditor>().openEditor(alarm: e);
                                },
                                slideIcon: Icons.delete,
                                onSlideTap: () => state.deleteInactiveAlarm(e),
                              ))
                          .toList(),
                    ),
                  )
                ],
              );
            },
          ),
        ),
        bottomSheet: GetX<AlarmEditor>(builder: (s) {
          return AnimatedCrossFade(
            crossFadeState: s.isOpen.value
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: const AlarmEditorWidget(
              key: Key('editor'),
            ),
            secondChild: const SizedBox(
              key: Key('holder'),
              height: 1,
            ),
            duration: const Duration(milliseconds: 100),
          );
        }),
        floatingActionButton: GetX<AlarmEditor>(builder: (s) {
          return s.isOpen.value
              ? FloatingActionButton(
                  onPressed: () => s.submit(),
                  child: const Icon(Icons.alarm_on))
              : FloatingActionButton(
                  onPressed: () => s.openEditor(),
                  child: const Icon(Icons.alarm_add));
        }),
      ),
    );
  }
}
