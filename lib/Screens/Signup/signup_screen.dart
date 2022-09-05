import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masteringflutterwithfirebase/constants.dart';
import '../../components/already_have_an_account_acheck.dart';
import '../../main.dart';
import '../HomePage/home_page.dart';
import '../Login/login_screen.dart';
import 'components/socal_sign_up.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  // ignore: prefer_typing_uninitialized_variables
  var myusername, myemail, mypassword;

  signUp() async {
    var formData = formState.currentState;
    if (formData!.validate()) {
      loadingOverlay(context);
      formData.save();
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: myemail,
          password: mypassword,
        );
        await FirebaseFirestore.instance
            .collection("users")
            .add({"username": myusername, "email": myemail});
        Get.off(() => const HomePage());
        if (kDebugMode) {
          print(credential.user!.email);
        }
        if (kDebugMode) {
          print(credential.user!.emailVerified);
        }
        if (credential.user!.emailVerified == false) {
          User? user = FirebaseAuth.instance.currentUser;
          await user!.sendEmailVerification();
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Navigator.of(context).pop();
          AwesomeDialog(
                  context: context,
                  title: "Error",
                  body: const Text("The password provided is too weak."))
              .show();
          if (kDebugMode) {
            print('The password provided is too weak.');
          }
        } else if (e.code == 'email-already-in-use') {
          Navigator.of(context).pop();
          AwesomeDialog(
                  context: context,
                  title: "Error",
                  body:
                      const Text("The account already exists for that email."))
              .show();
          if (kDebugMode) {
            print('The account already exists for that email.');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
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
              "SIGN UP",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Form(
              key: formState,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding),
                      child: TextFormField(
                        validator: (val) {
                          if (val!.length > 10) {
                            return "username cant to be larger than 10 letter";
                          } else if (val.length < 2) {
                            return "username cant to be less than 2 letter";
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        cursorColor: kPrimaryColor,
                        onSaved: (val) {
                          myusername = val!;
                        },
                        decoration: const InputDecoration(
                          hintText: "UserName",
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(defaultPadding),
                            child: Icon(Icons.person),
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      validator: (val) {
                        if (val!.length > 100) {
                          return "Email cant to be larger than 10 letter";
                        } else if (val.length < 2) {
                          return "Email cant to be less than 2 letter";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      cursorColor: kPrimaryColor,
                      onSaved: (val) {
                        myemail = val!;
                      },
                      decoration: const InputDecoration(
                        hintText: "E-mail",
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Icon(Icons.email),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding),
                      child: TextFormField(
                        validator: (val) {
                          if (val!.length > 20) {
                            return "Password cant to be larger than 10 letter";
                          } else if (val.length < 7) {
                            return "Password cant to be less than 2 letter";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) {
                          mypassword = val!;
                        },
                        textInputAction: TextInputAction.done,
                        obscureText: true,
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
                    const SizedBox(height: defaultPadding / 2),
                    ElevatedButton(
                      onPressed: () async {
                        var response = await signUp();
                        if (response != null) {
                          Get.offAll(() => const HomePage());
                        }
                      },
                      child: Text("Sign Up".toUpperCase()),
                    ),
                    const SizedBox(height: defaultPadding),
                    AlreadyHaveAnAccountCheck(
                      login: false,
                      press: () {
                        Get.offAll(() => const LoginScreen());
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SocalSignUp(),
          ],
        )),
      ),
    );
  }
}
