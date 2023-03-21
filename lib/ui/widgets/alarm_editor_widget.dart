import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapido_reminder/domain/states/alarm_editor.dart';

const channelKey = 'alarm_channel';

class AlarmEditorWidget extends StatelessWidget {
  const AlarmEditorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5.0,
        child: GetX<AlarmEditor>(
          builder: (state) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: TextEditingController(text: state.title.value),
                  decoration: const InputDecoration(labelText: 'Title'),
                  onSubmitted: state.title,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () => _pickupDate(state),
                      child: Text(state.dateStr.value)),
                  ElevatedButton(
                      onPressed: () => _pickupTime(state),
                      child: Text(state.timeStr.value)),
                  SizedBox(
                      width: 75,
                      child: TextField(
                        controller: TextEditingController(
                            text: state.durationStr.value),
                        decoration: const InputDecoration(labelText: 'In minutes'),
                        textAlign: TextAlign.center,
                        onSubmitted: (val) {
                          final duration = int.tryParse(val);
                          if (duration != null) {
                            state.setDuration(duration);
                          }
                        },
                      )),
                  IconButton(
                      onPressed: () => state.submit(),
                      icon: const Icon(Icons.save))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickupTime(AlarmEditor state, {DateTime? date}) async {
    final initTime = TimeOfDay.fromDateTime(state.alarmDate ?? DateTime.now());
    state.pickupDateTime(
        date: date,
        rawTimeVal: await Get.dialog<TimeOfDay>(
            TimePickerDialog(initialTime: initTime)));
  }

  _pickupDate(AlarmEditor state) async {
    final initDate = state.alarmDate ?? DateTime.now();
    _pickupTime(state,
        date: await Get.dialog<DateTime>(DatePickerDialog(
            initialDate: initDate,
            firstDate: initDate,
            lastDate: DateTime(initDate.year + 1))));
  }
}
