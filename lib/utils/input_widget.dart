import 'package:flutter/material.dart';

class InputWidget extends StatefulWidget {
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
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final controller = TextEditingController();
  bool isChanged = false;

  @override
  void initState() {
    controller.text = widget.text;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: widget.lable,
        border: const OutlineInputBorder(),
        suffix: isChanged
            ? InkWell(
                onTapUp: (_) {
                  widget.submit(controller.text);
                  isChanged = false;
                  setState(() {});
                },
                child: const Icon(Icons.check),
              )
            : null,
      ),
      keyboardType: widget.inputType,
      textAlign: TextAlign.center,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      onChanged: (v) {
        isChanged = controller.text == v;
        setState(() {});
      },
    );
  }
}
