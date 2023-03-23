import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapido_reminder/domain/states/alarm_editor.dart';
import 'package:rapido_reminder/utils/input_widget.dart';

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
                  child: InputWidget(
                      text: state.title.value,
                      lable: 'Title',
                      validator: _titleValidator,
                      submit: (val) {
                        if (val.isNotEmpty) {
                          state.title.value = val;
                        }
                      })),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () => _pickupDate(state),
                      child: Text(state.dateStr.value)),
                  ElevatedButton(
                      onPressed: () => _pickupTime(state),
                      child: Text(state.timeStr.value)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        width: 100,
                        child: InputWidget(
                            text: state.durationStr.value,
                            lable: 'In minutes',
                            validator: _minutesValidator,
                            inputType: TextInputType.number,
                            submit: (val) {
                              final duration = int.tryParse(val);
                              if (duration != null) {
                                state.setDuration(duration);
                              }
                            })),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickupTime(AlarmEditor state, {DateTime? date}) async {
    final initTime = TimeOfDay.fromDateTime(state.alarmDate);
    state.pickupDateTime(
        date: date,
        rawTimeVal: await Get.dialog<TimeOfDay>(
            TimePickerDialog(initialTime: initTime)));
  }

  _pickupDate(AlarmEditor state) async {
    final initDate = state.alarmDate;
    _pickupTime(state,
        date: await Get.dialog<DateTime>(DatePickerDialog(
            initialDate: initDate,
            firstDate: initDate,
            lastDate: DateTime(initDate.year + 1))));
  }

  String? _minutesValidator(String? val) {
    if (val != null) {
      final duration = int.tryParse(val);
      if (duration == null) {
        return 'Should be int';
      }
    }
    return null;
  }

  String? _titleValidator(String? val) {
    if (val == null || val.isEmpty) {
      return "Can't be empty";
    }
    return null;
  }
}
