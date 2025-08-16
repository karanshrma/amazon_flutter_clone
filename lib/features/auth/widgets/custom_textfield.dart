import 'dart:math';

import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({
    super.key,
    this.iconData,
    required this.controller,
    this.hintText = 'Name', // optional customization
    this.validator,
    this.onSaved,
    this.obscureText = false,
    this.maxlines = 1,
  });

  final Widget? iconData;
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final bool obscureText;
  final int maxlines;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        icon: iconData,
        hintText: hintText,
      ),
      onSaved: onSaved,
      validator: validator,
      obscureText: obscureText,
      maxLines: maxlines,
    );
  }
}
