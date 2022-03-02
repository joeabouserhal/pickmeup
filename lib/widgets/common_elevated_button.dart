// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {required this.child,
      required this.color,
      this.borderRadius = 14,
      required this.onPressed});

  final Widget child;
  final Color color;
  final double borderRadius;
  final VoidCallback onPressed;

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
