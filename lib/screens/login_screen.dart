import 'package:flutter/material.dart';
 import 'package:task_buddy/Constants/app_colors.dart';
import 'package:task_buddy/Constants/app_texts.dart';
import 'package:task_buddy/utils/password_validator.dart';
  import 'package:task_buddy/widgets/custome_%20ElevatedButton.dart';
import 'package:task_buddy/utils/custome_Snackbar.dart'; 
  import 'package:task_buddy/widgets/custome_TextButton.dart'; 
  import 'package:task_buddy/widgets/custome_textfield.dart';
   import 'signup_screen.dart'; 
    import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
   @override State<LoginScreen> createState() => _LoginScreenState(); }

class _LoginScreenState extends State<LoginScreen> { 
  final TextEditingController phoneController = TextEditingController();
   final TextEditingController emailController = TextEditingController(); 
   final TextEditingController passwordController = TextEditingController(); 
   bool isLoading = false;

void loginUser() async {
   String email = emailController.text.trim();
    String password = passwordController.text.trim();

if (email.isEmpty || password.isEmpty) {
CustomSnackBar.show(context, message: AppTexts.emptyEmailPassword,isError: true);
  return;
}
String? passwordError = PasswordValidator.validate(password);
if(passwordError!=null){CustomSnackBar.show(context, message: passwordError,isError:true);
return;
}
try {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );

 CustomSnackBar.show(context, message:AppTexts.loginSuccess);

  // Navigator.pushReplacementNamed(context, '/home');

} on FirebaseAuthException catch (e) {
 CustomSnackBar.show(context, message: "${AppTexts.loginFailed}${e.message}",isError: true);
}
}

void showForgotPasswordDialog(BuildContext context) {
   final TextEditingController resetEmailController = TextEditingController();

showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text(AppTexts.resetPasswordTitle),
    content: TextField(
      controller: resetEmailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(hintText: AppTexts.resetPasswordHint),
    ),
    actions: [
      TextButton(
        onPressed: () async {
          try {
            await FirebaseAuth.instance.sendPasswordResetEmail(
              email: resetEmailController.text.trim(),
            );
            Navigator.of(context).pop();
            CustomSnackBar.show(context, message: AppTexts.resetEmailSent);
            
          } catch (e) {
            CustomSnackBar.show(context, message: "${AppTexts.resetError} ${e.toString()}",isError: true);
          }
        },
        child: Text(AppTexts.send),
      ),
    ],
  ),
);
}
@override Widget build(BuildContext context) {
   return Scaffold( 
    body:
    Padding( padding: const EdgeInsets.all(20.0),
     child: Center( child: SingleChildScrollView(
       child: Column(
         children: [
           FlutterLogo(size: 80),
            SizedBox(height: 20), Text(AppTexts.appName, 
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
             ), SizedBox(height: 20), 
             CustomTextField
             ( 
              hintText: AppTexts.enterEmail,
               controller: emailController,
                ), SizedBox(height: 10), 

                CustomTextField(
                   hintText: AppTexts.enterPassword,
                   controller: passwordController, isPassword: true,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                     CustomTextButton( 
                      text: AppTexts.forgotPassword, onPressed: () => showForgotPasswordDialog(context),
                    )]), SizedBox(height: 20), 
                       isLoading ? 
                       const CircularProgressIndicator() : CustomElevatedButton(
                         text: AppTexts.loginTitle, onPressed: loginUser, color: AppColors.primaryColor, fullWidth: true, ),
                          CustomTextButton( text: AppTexts.dontHaveAccount, onPressed: () {
                             Navigator.push( context, MaterialPageRoute(builder: (_) => SignupScreen()
                             ),
                              )
                              ;
                               },
                                ) 
                                ],
                                 ),
                                  ),
                                   ),
                                    ),
                                     ); 
                                     } 
}