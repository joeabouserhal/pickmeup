import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/sign_in_button.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark),
          backgroundColor: Colors.grey[200],
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(25, 100, 0, 40),
                child: Text(
                  'Enter your email',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: const TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.email),
                      hintText: 'Email',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              SignInButton(
                  text: 'Change My Password',
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: _forgotMyPassword),
            ])));
  }

  void _forgotMyPassword() {}
}
