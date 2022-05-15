import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickmeup/models/customer.dart';
import 'package:pickmeup/pages/driver_login_email_page.dart';
import 'package:pickmeup/pages/driver_main_page.dart';
import 'package:pickmeup/pages/driver_sign_up_page.dart';
import 'package:pickmeup/pages/main_page.dart';

import '../widgets/sign_in_button.dart';

class DriverLoginPage extends StatelessWidget {
  const DriverLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.grey[200],
        ),
        backgroundColor: Colors.grey[200],
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
          child: Column(
        // main axis is vertically
        mainAxisAlignment: MainAxisAlignment.center,
        // cross axis is horizontally
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 0, 40),
            child: Row(children: const [
              Text(
                'Driver Login',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 10),
              Icon(Icons.drive_eta_rounded, size: 50, color: Colors.black),
            ]),
          ),
          SignInButton(
              text: "Sign in as Driver with Email",
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DriverLoginEmailPage()),
                );
              }),
          const SizedBox(height: 15),
          SignInButton(
              text: 'Sign in as Guest Driver',
              color: Colors.blueGrey,
              textColor: Colors.white,
              onPressed: () {
                FirebaseAuth.instance
                    .signInAnonymously()
                    .then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainPage(
                                    email: value.user?.email,
                                    uid: value.user?.uid,
                                  )),
                        ));
              }),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'or',
              textAlign: TextAlign.center,
            ),
          ),
          SignInButton(
              text: 'Sign up as Driver',
              color: const Color.fromARGB(255, 181, 189, 194),
              textColor: Colors.black87,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DriverSignUpPage()),
                );
              }),
        ],
      )),
    );
  }
}
