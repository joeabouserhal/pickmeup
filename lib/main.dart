import 'package:flutter/material.dart';

import 'package:pickmeup/blocs/application_bloc.dart';
import 'package:pickmeup/pages/login_screen.dart';
import 'package:provider/provider.dart';

void main(List<String> args) async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginScreen(),
    );
  }
}
