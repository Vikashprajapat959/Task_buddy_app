import 'dart:typed_data';
import 'dart:io' as io;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:task_buddy/Constants/app_colors.dart';
import 'package:task_buddy/Constants/app_texts.dart';
import 'package:task_buddy/Constants/app_styles.dart';
import 'package:task_buddy/screens/login_screen.dart';
import 'package:task_buddy/utils/custome_Snackbar.dart';
import 'package:task_buddy/utils/password_validator.dart';
import 'package:task_buddy/widgets/custome_%20ElevatedButton.dart';
import 'package:task_buddy/widgets/custome_TextButton.dart';
import 'package:task_buddy/widgets/custome_textfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  io.File? _imageFile; // For Mobile
  Uint8List? _webImageBytes; // For Web
  bool isLoading = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
        });
      } else {
        setState(() {
          _imageFile = io.File(picked.path);
        });
      }
    }
  }

  Future<String> uploadImage() async {
    final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = FirebaseStorage.instance.ref().child('profile_images/$fileName');

    if (kIsWeb && _webImageBytes != null) {
      await ref.putData(_webImageBytes!);
    } else if (_imageFile != null) {
      await ref.putFile(_imageFile!);
    }

    return await ref.getDownloadURL();
  }

  void signUpUser() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmController.text.trim();

    final isImagePicked = kIsWeb ? _webImageBytes != null : _imageFile != null;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty || !isImagePicked) {
      CustomSnackBar.show(context, message: AppTexts.fillAllFields, isError: true);
      return;
    }

    if (password != confirm) {
      CustomSnackBar.show(context, message: AppTexts.passwordsDoNotMatch, isError: true);
      return;
    }

    final passwordError = PasswordValidator.validate(password);
    if (passwordError != null) {
      CustomSnackBar.show(context, message: passwordError, isError: true);
      return;
    }

    setState(() => isLoading = true);
    try {
      final userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final imageUrl = await uploadImage();

      await userCred.user?.updateDisplayName(name);
      await userCred.user?.updatePhotoURL(imageUrl);

      await FirebaseFirestore.instance.collection('users').doc(userCred.user!.uid).set({
        'uid': userCred.user!.uid,
        'name': name,
        'email': email,
        'photoUrl': imageUrl,
      });

      CustomSnackBar.show(context, message: AppTexts.signupSuccess);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      CustomSnackBar.show(context, message: "${AppTexts.signupFailed} ${e.message}", isError: true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTexts.signupTitle),
        backgroundColor: AppColors.primaryColor,
        titleTextStyle: AppTextStyles.headerMedium.copyWith(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
             GestureDetector(
  onTap: pickImage,
  child: CircleAvatar(
    radius: 40,
    backgroundImage: kIsWeb
        ? (_webImageBytes != null ? MemoryImage(_webImageBytes!) : null)
        : (_imageFile != null ? Image.file(_imageFile!).image : null),
    child: (kIsWeb && _webImageBytes == null) || (!kIsWeb && _imageFile == null)
        ? const Icon(Icons.add_a_photo)
        : null,
  ),
),
              const SizedBox(height: 10),
              CustomTextField(hintText: "Enter name", controller: nameController),
              const SizedBox(height: 10),
              CustomTextField(hintText: AppTexts.enterEmail, controller: emailController),
              const SizedBox(height: 10),
              CustomTextField(hintText: AppTexts.enterPassword, controller: passwordController, isPassword: true),
              const SizedBox(height: 10),
              CustomTextField(hintText: AppTexts.confirmPassword, controller: confirmController, isPassword: true),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : CustomElevatedButton(
                      text: AppTexts.signupTitle,
                      onPressed: signUpUser,
                      color: AppColors.primaryColor,
                      fullWidth: true,
                    ),
              const SizedBox(height: 10),
              CustomTextButton(
                text: AppTexts.alreadyHaveAccount,
                onPressed: () {
                  Navigator.pop(context, MaterialPageRoute(builder: (_) =>  LoginScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}