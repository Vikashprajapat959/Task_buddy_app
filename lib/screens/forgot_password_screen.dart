import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_buddy/utils/custome_snackbar.dart';
import 'package:task_buddy/Constants/app_texts.dart';
import 'package:task_buddy/widgets/custome_%20ElevatedButton.dart';
import 'package:task_buddy/widgets/custome_textfield.dart';
import 'package:task_buddy/Constants/app_colors.dart';
import 'package:task_buddy/Constants/app_styles.dart'; // 👈 import style file

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}   

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  void sendResetLink() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      CustomSnackBar.show(context,
          message: AppTexts.EnterEmail, isError: true);
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      CustomSnackBar.show(context, message: AppTexts.resetEmailSent);
      Navigator.pop(context);
    } catch (e) {
      CustomSnackBar.show(context,
          message: "${AppTexts.resetError} ${e.toString()}",
          isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(AppTexts.resetPasswordTitle),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 👈 align text left
          children: [
            Text(
              AppTexts.resetPasswordSubtitle,
              style: AppTextStyles.bodyMedium, // 👈 centralized style used
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hintText: AppTexts.resetPasswordHint,
              controller: emailController,
            ),
            const SizedBox(height: 20),
            CustomElevatedButton(
              text: AppTexts.send,
              onPressed: sendResetLink,
              color: AppColors.primaryColor,
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}