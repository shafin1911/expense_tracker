import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    super.key,
    required this.title,
    this.prefix = "",
    required this.textEditController,
  });
  final String title;
  final String prefix;
  final TextEditingController textEditController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: textEditController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          prefix: prefix.isNotEmpty ? Text(prefix) : null,
          label: Text(title),
        ),
      ),
    );
  }
}
