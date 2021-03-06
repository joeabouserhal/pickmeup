import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pickmeup/pages/driver_login_page.dart';
import 'package:pickmeup/pages/login_email_page.dart';
import 'package:pickmeup/pages/main_page.dart';
import 'package:pickmeup/pages/sign_up_page.dart';
import 'package:pickmeup/widgets/sign_in_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'driver_main_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    checkLogin(context);
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.grey[200],
        ),
        automaticallyImplyLeading: false,
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
          SignInButton(
              text: "Sign in with Email",
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginEmailPage()),
                );
              }),
          const SizedBox(height: 15),
          SignInButton(
              text: 'Sign in as Guest',
              color: Colors.blueGrey,
              textColor: Colors.white,
              onPressed: () {
                FirebaseAuth.instance
                    .signInAnonymously()
                    .then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainPage()),
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
              text: 'Sign up',
              color: const Color.fromARGB(255, 181, 189, 194),
              textColor: Colors.black87,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              }),
          const SizedBox(height: 20),
          GestureDetector(
            child: Center(
              child: Text(
                "Are you a Driver?",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const DriverLoginPage()));
            },
          ),
        ],
      )),
    );
  }

  checkLogin(context) async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');
    final String? password = prefs.getString('password');
    final bool? isCustomer = prefs.getBool('isCustomer');
    final bool? isDriver = prefs.getBool('isDriver');
    if (email != null && password != null) {
      if (isCustomer == true) {
        FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
            .then((value) {
          Fluttertoast.showToast(
              msg: 'Successfully logged in as ${value.user?.email}');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MainPage(),
            ),
          );
        }).onError((error, stackTrace) {
          Fluttertoast.showToast(msg: 'Error: $error');
          throw error.toString();
        });
      } else if (isDriver == true) {
        FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
            .then((value) {
          Fluttertoast.showToast(
              msg: 'Successfully logged in as ${value.user?.email}');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DriverMainPage(),
            ),
          );
        }).onError((error, stackTrace) {
          Fluttertoast.showToast(msg: 'Error: $error');
          throw error.toString();
        });
      }
    }
  }
}
