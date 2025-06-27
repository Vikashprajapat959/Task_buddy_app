import 'package:flutter/material.dart';
import 'package:task_buddy/Constants/app_colors.dart';
import 'package:task_buddy/Constants/app_texts.dart';
import 'package:task_buddy/screens/login_screen.dart';
import 'package:task_buddy/utils/custome_Snackbar.dart';
import 'package:task_buddy/utils/password_validator.dart';
import 'package:task_buddy/widgets/custome_%20ElevatedButton.dart';
import 'package:task_buddy/widgets/custome_TextButton.dart';
import 'package:task_buddy/widgets/custome_textfield.dart';
 import 'package:firebase_auth/firebase_auth.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}
class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  bool isLoading = false;
  void signUpUser() async {
  String email = emailController.text.trim();
  String password = passwordController.text.trim();
  String confirm = confirmController.text.trim();

  // 🔒 Validation: Sab field bhare ho
  if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
   CustomSnackBar.show(context, message:AppTexts.fillAllFields,isError: true);
    return;
  }

  // 🔒 Password match check
  if (password != confirm) {
    CustomSnackBar.show(context, message: AppTexts.passwordsDoNotMatch,isError: true);
    return;
  }
  // 🔁 Show loading
  setState(() {
    isLoading = true;
  });
String? passwordError = PasswordValidator.validate(password);
if(passwordError!=null){CustomSnackBar.show(context, message: passwordError,isError:true);
return;}
  try {
    // ✅ Firebase pe user create karo
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    CustomSnackBar.show(context, message: AppTexts.signupSuccess);
    // 🔙 Login screen pe wapas
    Navigator.pop(context);
  } on FirebaseAuthException catch (e) {
    // ❌ Error message show
    CustomSnackBar.show(context, message: "${AppTexts.signupFailed} ${e.message}",isError: true);
  } finally {
    // 🔁 Hide loading
    setState(() {
      isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppTexts.signupTitle)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
              CustomTextField(
                  hintText: AppTexts.confirmPassword,
                  controller: confirmController,
                  isPassword: true,
                ),
              const SizedBox(height: 20),
              isLoading
              ? const
              CircularProgressIndicator():
              CustomElevatedButton(
                   text: AppTexts.signupTitle,
              
                  color: AppColors.primaryColor,
                  fullWidth: true,
                onPressed: signUpUser,
               
              ),
                    CustomTextButton(
  text: AppTexts.alreadyHaveAccount,
  onPressed: () {
    Navigator.pop(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  },
)
            ],
          ),
        ),
      ),
    );
  }
}