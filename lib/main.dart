import 'package:flutter/material.dart';
import 'package:task_buddy/Constants/app_thems.dart';
import 'package:task_buddy/screens/Home_screen.dart';
import 'package:task_buddy/screens/forgot_password_screen.dart';
import 'package:task_buddy/screens/signup_screen.dart';
import 'screens/login_screen.dart';
 import 'package:firebase_core/firebase_core.dart'; // Agar Firebase use karo to uncomment karo
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
  options: const FirebaseOptions(
  apiKey: "AIzaSyDV3sDqRxNk5hEnm-NGW73A-XnA_K1E4H0",
  appId: "1:268328542457:android:cf2e43ffaf11b95092c228",
  messagingSenderId: "268328542457",
  projectId: "taskbuddyapp-7b38f",
  storageBucket: "taskbuddyapp-7b38f.appspot.com",
),
);
  runApp(const TaskBuddyApp());
}
class TaskBuddyApp extends StatelessWidget {
  const TaskBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskBuddy',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) =>  LoginScreen(),
        '/signup': (context) =>  SignupScreen(),
        '/ForgotPasswordScreen': (context) => ForgotPasswordScreen(),
        '/Homescreen': (context) => HomeScreen(),
      },
    );
  }
}