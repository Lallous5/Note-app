import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masteringflutterwithfirebase/Screens/HomePage/home_page.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  // ignore: prefer_typing_uninitialized_variables
  var myusername, myemail, mypassword;

  signUp() async {
    var formData = formState.currentState;
    if (formData!.validate()) {
      formData.save();
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: myemail,
          password: mypassword,
        );

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
          AwesomeDialog(
                  context: context,
                  title: "Error",
                  body: const Text("The password provided is too weak."))
              .show();
          if (kDebugMode) {
            print('The password provided is too weak.');
          }
        } else if (e.code == 'email-already-in-use') {
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
    } else {
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
    return Form(
      key: formState,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
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
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
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
              var user = await signUp();
              if (user != null) {
                Get.offAll(() => const HomePage());
              }
            },
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Get.offAll(() =>  const LoginScreen());
            },
          ),
        ],
      ),
    );
  }
}
