import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/sign_in_button.dart';

bool _isObscure = true;

class DriverSignUpPage extends StatefulWidget {
  const DriverSignUpPage({Key? key}) : super(key: key);

  @override
  State<DriverSignUpPage> createState() => _DriverSignUpPageState();
}

class _DriverSignUpPageState extends State<DriverSignUpPage> {
  // global key used for form validation
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  // text editor controllers
  final _emailTextController = TextEditingController();
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _licenseNumberTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _passwordConfirmTextController = TextEditingController();
  final _phoneNumberTextController = TextEditingController();

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
            child: Center(
                child: Column(
              // main axis is vertically
              mainAxisAlignment: MainAxisAlignment.center,
              // cross axis is horizontally
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(25, 100, 0, 40),
                  child: Text(
                    'Sign Up as Driver',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(children: [
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          controller: _firstNameTextController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.person),
                            hintText: 'First Name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '  Field is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          controller: _lastNameTextController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.person),
                            hintText: 'Last Name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '  Field is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ]),
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
                      controller: _phoneNumberTextController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.phone),
                        hintText: 'Phone Number (+961)',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '  Please enter your Phone Number';
                        }
                        if (!RegExp(r'[0-9]{8}').hasMatch(value)) {
                          return '  Invalid Phone Number';
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
                      controller: _licenseNumberTextController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.drive_eta_rounded),
                        hintText: 'License Number',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '  Please enter your license number';
                        }
                        if (!RegExp(r'/[a-zA-Z]{1,6}/').hasMatch(value)) {
                          return '  Invalid License Number, ex: B123456';
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
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                        hintText: 'Password',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '  Please enter your password';
                        }
                        if (!RegExp(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~-]).{8,}$')
                            .hasMatch(value)) {
                          return '  Invalid Password, must contain:\n  * at least 1 capital letter\n  * at least 1 lowercase letter\n  * at least 1 number\n  * at least 1 special character\n  * at least 8 characters long';
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
                      controller: _passwordConfirmTextController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.lock),
                        hintText: 'Re-enter Password',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '  Please re-enter your password';
                        }
                        if (value != _passwordTextController.text) {
                          return '  Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                SignInButton(
                    text: 'Sign Up',
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        _key.currentState!.save();
                        _signUpWithEmail();
                      }
                    }),
              ],
            )),
          ),
        ));
  }

  void _signUpWithEmail() {}
}
