import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/already_have_an_account_acheck.dart';
import '../../constants.dart';
import '../../main.dart';
import '../HomePage/home_page.dart';
import '../Signup/components/socal_sign_up.dart';
import '../Signup/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  // ignore: prefer_typing_uninitialized_variables
  var myemail, mypassword;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  signIn() async {
    var formData = formState.currentState;
    if (formData!.validate()) {
      loadingOverlay(context);
      formData.save();
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim());
        Get.off(() => const HomePage());
        if (kDebugMode) {
          print(credential.user!.emailVerified);
        }
        if (credential.user!.emailVerified == false) {
          User? user = FirebaseAuth.instance.currentUser;
          await user!.sendEmailVerification();
        }
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "TokenId": await FirebaseMessaging.instance.getToken(),
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Navigator.of(context).pop();
          AwesomeDialog(
                  context: context,
                  title: "Error",
                  body: const Text("user-not-found."))
              .show();
          if (kDebugMode) {
            print('No user found for that email.');
          }
        } else if (e.code == 'wrong-password') {
          Navigator.of(context).pop();
          AwesomeDialog(
                  context: context,
                  title: "Error",
                  body: const Text("Wrong password provided for that user."))
              .show();
          if (kDebugMode) {
            print('Wrong password provided for that user.');
          }
        }
      }
    } else {
      Navigator.of(context).pop();
      AwesomeDialog(
              context: context, title: "Error", body: const Text("Not Valid"))
          .show();
      if (kDebugMode) {
        print("Not Valid");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
            child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Welcome To Your App Note",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: formState,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Image.asset("assets/images/login.png"),
                    const SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      cursorColor: kPrimaryColor,
                      controller: emailController,
                      
                      decoration: const InputDecoration(
                        hintText: "E-mail",
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Icon(Icons.person),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding),
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        controller: passwordController,
                        cursorColor: kPrimaryColor,
                        decoration: const InputDecoration(
                          hintText: "Password",
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(defaultPadding),
                            child: Icon(Icons.lock),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    Hero(
                      tag: "login_btn",
                      child: ElevatedButton(
                        onPressed: () {
                          signIn();
                        },
                        child: Text(
                          "Login".toUpperCase(),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    AlreadyHaveAnAccountCheck(
                      press: () {
                        Get.offAll(() => const SignUpScreen());
                      },
                    ),
                  ],
                ),
              ),
            ),
            
          ],
        )),
      ),
    );
  
  }
}
