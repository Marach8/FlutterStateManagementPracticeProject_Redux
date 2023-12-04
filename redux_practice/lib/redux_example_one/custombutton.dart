import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressed; final String text;
  const CustomButton({required this.onPressed, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}