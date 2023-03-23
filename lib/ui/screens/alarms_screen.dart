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
          child: Column(
            children: [
              GetX<AlarmsManager>(
                builder: (state) {
                  return Flexible(
                    child: ListView(
                      children: state.alarms
                          .map((e) => AlarmWidget(item: e))
                          .toList(),
                    ),
                  );
                },
              ),
            ],
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
