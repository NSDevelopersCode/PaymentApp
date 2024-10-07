import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.hint,
    required this.validator,
  });
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      validator: validator,
      keyboardType: TextInputType.number,
      controller: controller,
      decoration: InputDecoration(
        focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 0.6, color: Colors.red)),
        label: Text(
          hint,
          style: TextStyle(fontSize: 12, color: Colors.deepPurple.shade200),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 2, color: Theme.of(context).primaryColor)),
        enabled: true,
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 0.6, color: Theme.of(context).primaryColor)),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 0.6, color: Colors.red)),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.deepPurple.shade200, fontSize: 13),
      ),
    );
  }
}
