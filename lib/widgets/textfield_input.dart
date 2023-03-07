import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final bool ispass;
  final String hintText;
  final TextInputType textInputType;
  final TextEditingController textEditingController;
  const TextFieldInput(
      {Key? key,
      required this.hintText,
      this.ispass = false,
      required this.textInputType,
      required this.textEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: textEditingController,
      obscureText: ispass,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
      ),
    );
  }
}
