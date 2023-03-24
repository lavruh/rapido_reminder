import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapido_reminder/domain/states/alarm_editor.dart';
import 'package:rapido_reminder/domain/states/alarm_manager.dart';
import 'package:rapido_reminder/ui/screens/alarms_screen.dart';

const channelKey = 'alarm_channel';

Future<void> actionReceived(ReceivedAction a) async {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: channelKey,
      channelName: 'Alarm Notifications',
      defaultColor: Colors.grey,
      channelDescription: 'alarm_channel',
      criticalAlerts: true,
      enableLights: true,
      ledColor: Colors.orange,
      ledOnMs: 100,
      ledOffMs: 100,
      enableVibration: true,
      importance: NotificationImportance.High,
    )
  ]);
  Get.put<AlarmEditor>(AlarmEditor());
  Get.put<AlarmsManager>(AlarmsManager());
  Get.put<AudioPlayer>(AudioPlayer());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: actionReceived,
        onNotificationDisplayedMethod: (a) async {
          Get.find<AudioPlayer>()
              .play(AssetSource('sounds/digital-alarm-buzzer.wav'));
        },
        onDismissActionReceivedMethod: (a) async {
          Get.find<AudioPlayer>().stop();
          final id = a.id;
          if(id != null) {
            Get.find<AlarmsManager>().moveAlarmToInactive(id);
          }
        });
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AlarmsScreen(),
    );
  }
}
