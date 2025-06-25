import 'package:flutter/material.dart';
import 'package:task_buddy/Constant/app_constant.dart';
import 'package:task_buddy/widgets/custome_textfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  void signUpUser() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirm = confirmController.text.trim();

    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    // 🔐 Firebase sign-up logic yahan aayega
    print("Signup with: $email / $password");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Signup Successful (Demo)")),
    );

    Navigator.pop(context); // Back to LoginScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
             CustomTextField(
                  hintText: "Enter Email",
                  controller: emailController,
                ),
              const SizedBox(height: 10),
              CustomTextField(
                  hintText: "Enter Password",
               controller: passwordController,
                ),
              const SizedBox(height: 10),
              CustomTextField(
                  hintText: "Enter Confirm password",
                  controller: confirmController,
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryColor,
    minimumSize: const Size.fromHeight(55), // 👈 Height match karo
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
    ),
  ),
                onPressed: signUpUser,
                child: Text("Sign Up"),
              ),
              TextButton(
                  onPressed: () {
                  },
                  child: Text("Already have an account?Login"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}