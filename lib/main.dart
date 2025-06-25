import 'package:flutter/material.dart';
import 'package:task_buddy/screens/signup_screen.dart';
import 'screens/login_screen.dart';

// import 'package:firebase_core/firebase_core.dart'; // Agar Firebase use karo to uncomment karo

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); // Agar Firebase connect kiya ho to use karo
  runApp(const TaskBuddyApp());
}

class TaskBuddyApp extends StatelessWidget {
  const TaskBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskBuddy',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) =>  LoginScreen(),
        '/signup': (context) => const SignupScreen(),
      //  '/home': (context) => HomeScreen(),
      },
    );
  }
}