import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.labelText,
      required this.hintText,
      required this.preIcon,
      required this.validator,
      required this.obsecure,
      this.sufIcon,
      required this.callback});
  final void Function(String) callback;
  final String labelText;
  final String hintText;
  final IconData preIcon;
  final FormFieldValidator validator;
  final bool obsecure;
  final IconButton? sufIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      obscureText: obsecure,
      onChanged: callback,
      decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          suffixIcon: sufIcon,
          prefixIcon: Icon(preIcon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }
}
