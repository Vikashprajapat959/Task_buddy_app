import 'package:flutter/material.dart';
import 'package:task_buddy/Constants/app_styles.dart'; // <-- Make sure you import this

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: AppTextStyles.bodyMedium.copyWith(color: Colors.black), // <-- User text style
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600]), // <-- Hint text style
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}