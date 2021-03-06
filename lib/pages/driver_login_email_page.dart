import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pickmeup/pages/forgot_password_page.dart';

import 'package:pickmeup/widgets/sign_in_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'driver_main_page.dart';

bool _isObscure = true;

class DriverLoginEmailPage extends StatefulWidget {
  const DriverLoginEmailPage({Key? key}) : super(key: key);

  @override
  _DriverLoginEmailPageState createState() => _DriverLoginEmailPageState();
}

class _DriverLoginEmailPageState extends State<DriverLoginEmailPage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

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
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(25, 100, 0, 40),
                child: Text(
                  'Sign in as Driver with Email',
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
                  child: TextFormField(
                    controller: _emailTextController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.email),
                      hintText: 'Email',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '  Please enter your email';
                      }
                      if (!RegExp(r'\w+@\w+\.\w+').hasMatch(value)) {
                        return '  Invalid Email Address';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: TextFormField(
                    controller: _passwordTextController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '  Please enter your password';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                      hintText: 'Password',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                child: Center(
                  child: Text(
                    "Forgot my password",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ForgotPasswordPage()));
                },
              ),
              const SizedBox(height: 60),
              SignInButton(
                  text: 'Log In',
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      _key.currentState!.save();
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text,
                      )
                          .then((value) {
                        saveLoginData(_emailTextController.text,
                            _passwordTextController.text);
                        Fluttertoast.showToast(
                            msg:
                                'Successfully logged in as ${value.user?.email}');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DriverMainPage()));
                      }).onError((error, stackTrace) {
                        Fluttertoast.showToast(msg: 'Error: $error');
                        throw error.toString();
                      });
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

saveLoginData(String email, String password) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('email', email);
  await prefs.setString('password', password);
  await prefs.setBool('isDriver', true);
}
