import 'package:flutter/material.dart';
import 'package:task_buddy/Constant/app_constant.dart';
import 'package:task_buddy/widgets/custome_textfield.dart';
import 'signup_screen.dart';
  import 'package:firebase_auth/firebase_auth.dart'; 


class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();



void loginUser() async {
  String email = emailController.text.trim();
  String password = passwordController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please enter email & password")),
    );
    return;
  }

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Login Successful ✅")),
    );

    // Login ke baad home ya dashboard pe le jao
    // Navigator.pushReplacementNamed(context, '/home');

  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Login failed: ${e.message}")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                FlutterLogo(size: 80),
                SizedBox(height: 20),
                Text(
                  "TaskBuddy",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hintText: "Enter Email",
                  controller: emailController,
                ),
                SizedBox(height: 10),
                CustomTextField(
                  hintText: "Enter Password",
                  controller: passwordController,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                   style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryColor,
    minimumSize: const Size.fromHeight(55), // 👈 Height match karo
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
    ),
  ),
                  onPressed: loginUser,
                  child: Text("Login",),), 
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SignupScreen()),
                    );
                  },
                  child: Text("Don't have an account? Sign up here"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}