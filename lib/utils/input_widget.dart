import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  const InputWidget(
      {Key? key,
      required this.text,
      required this.lable,
      required this.validator,
      required this.submit,
      this.inputType})
      : super(key: key);
  final String text;
  final String lable;
  final String? Function(String?) validator;
  final Function(String) submit;
  final TextInputType? inputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: TextEditingController(text: text),
      decoration: InputDecoration(
          labelText: lable,
          border: const OutlineInputBorder()),
      keyboardType: inputType,
      textAlign: TextAlign.center,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      onFieldSubmitted: submit,
    );
  }
}

