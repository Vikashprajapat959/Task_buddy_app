import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_buddy/Constants/app_colors.dart';
import 'package:task_buddy/Constants/app_texts.dart';
import 'package:task_buddy/Constants/app_styles.dart';
import 'package:task_buddy/screens/Home_screen.dart';
import 'package:task_buddy/screens/forgot_password_screen.dart';
import 'package:task_buddy/utils/password_validator.dart';
import 'package:task_buddy/utils/custome_Snackbar.dart';
import 'package:task_buddy/widgets/custome_%20ElevatedButton.dart';
import 'package:task_buddy/widgets/custome_TextButton.dart';
import 'package:task_buddy/widgets/custome_textfield.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void loginUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      CustomSnackBar.show(
        context,
        message: AppTexts.emptyEmailPassword,
        isError: true,
      );
      return;
    }

    String? passwordError = PasswordValidator.validate(password);
    if (passwordError != null) {
      CustomSnackBar.show(context, message: passwordError, isError: true);
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      CustomSnackBar.show(context, message: AppTexts.loginSuccess);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      CustomSnackBar.show(
        context,
        message: "${AppTexts.loginFailed}${e.message}",
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const FlutterLogo(size: 80),
                const SizedBox(height: 20),
                Text(
                  AppTexts.appName,
                  style: AppTextStyles.headerLarge,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: AppTexts.enterEmail,
                  controller: emailController,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: AppTexts.enterPassword,
                  controller: passwordController,
                  isPassword: true,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        AppTexts.forgotPassword,
                        style: AppTextStyles.textButton,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator()
                    : CustomElevatedButton(
                        text: AppTexts.loginTitle,
                        onPressed: loginUser,
                        color: AppColors.primaryColor,
                        fullWidth: true,
                      ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppTexts.dontHaveAccount,
                      style: AppTextStyles.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SignupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        AppTexts.signupTitle,
                        style: AppTextStyles.textButton,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}