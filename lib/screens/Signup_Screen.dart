import 'package:flutter/material.dart';
import 'package:task_buddy/Constant/app_constant.dart';
import 'package:task_buddy/screens/login_screen.dart';
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill all fields")),
    );
    return;
  }

  // 🔒 Password match check
  if (password != confirm) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Passwords do not match")),
    );
    return;
  }

  // 🔁 Show loading
  setState(() {
    isLoading = true;
  });

  try {
    // ✅ Firebase pe user create karo
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Signup Successful ✅")),
    );

    // 🔙 Login screen pe wapas
    Navigator.pop(context);
  } on FirebaseAuthException catch (e) {
    // ❌ Error message show
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Signup failed: ${e.message}")),
    );
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
               isPassword: true,
                ),
              const SizedBox(height: 10),
              CustomTextField(
                  hintText: "Enter Confirm password",
                  controller: confirmController,
                  isPassword: true,
                ),
              const SizedBox(height: 20),
              isLoading
              ? const
              CircularProgressIndicator():
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
                    Navigator.pop(context ,MaterialPageRoute(builder: (_) => LoginScreen()),);//back to login 
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