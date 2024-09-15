import 'package:flutter/material.dart';

class CustomInputFields extends StatelessWidget {
  final Function(String) onSaved;
  final String regEx;
  final String hintText;
  final bool obsecureText;

  const CustomInputFields(
      {required this.onSaved,
      required this.regEx,
      required this.hintText,
      required this.obsecureText,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        onSaved: (_value) => onSaved(_value!),
        cursorColor: Colors.white,
        style: const TextStyle(
          color: Colors.white,
        ),
        obscureText: obsecureText,
        validator: (_value) {
          return RegExp(regEx).hasMatch(_value!) ? null : 'Enter valid value';
        },
        decoration: InputDecoration(
            fillColor: Color.fromRGBO(30, 29, 37, 1.0),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.white54)));
  }
}
