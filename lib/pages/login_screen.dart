import 'package:flutter/material.dart';
import 'package:pickmeup/pages/login_email_screen.dart';
import 'package:pickmeup/pages/main_screen.dart';
import 'package:pickmeup/widgets/sign_in_button.dart';
import 'package:pickmeup/widgets/sign_in_social_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
          child: Column(
        // main axis is vertically
        mainAxisAlignment: MainAxisAlignment.center,
        // cross axis is horizontally
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(25, 0, 0, 40),
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SocialSignInButton(
              text: "Sign in with Google",
              color: Colors.white,
              textColor: Colors.black87,
              imageAssetName: 'images/google-logo.png',
              onPressed: _signInWithGoogle),
          const SizedBox(height: 15),
          SignInButton(
              text: "Sign in with Email",
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginEmailScreen()),
                );
              }),
          const SizedBox(height: 15),
          SignInButton(
              text: 'Sign in as Guest',
              color: Colors.blueGrey,
              textColor: Colors.white,
              onPressed: () {
                _signInAsGuest();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                );
              }),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'or',
              textAlign: TextAlign.center,
            ),
          ),
          SignInButton(
              text: 'Sign up',
              color: const Color.fromARGB(255, 181, 189, 194),
              textColor: Colors.black87,
              onPressed: _signUp),
        ],
      )),
    );
  }

  void _signInWithGoogle() {
    print('sign in with google');
  }

  void _signInWithFacebook() {
    print('sign in with facebook');
  }

  void _signInAsGuest() {
    print('sign in as guest');
  }

  void _signUp() {
    print('sign up');
  }
}
