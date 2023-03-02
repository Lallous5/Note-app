import 'package:flutter/material.dart';
import 'components/login_signup_btn.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              SizedBox(
                height: 50,
              ),
              Text(
                "WELCOME TO YOUR NOTES",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Image.asset("assets/images/splashimage.png"),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: EdgeInsets.all(30),
                child: LoginAndSignupBtn(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
