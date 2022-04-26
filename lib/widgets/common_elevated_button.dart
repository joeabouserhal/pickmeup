// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton(
      {required this.child,
      this.color = Colors.cyan,
      this.borderRadius = 14,
      required this.onPressed});

  Widget child;
  Color color;
  double borderRadius;
  VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius))),
              backgroundColor: MaterialStateProperty.all<Color>(color),
            ),
            child: child),
      ),
    );
  }
}
