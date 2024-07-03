import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;

  const TextFieldWidget({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(border: OutlineInputBorder()),
    );
  }
}
