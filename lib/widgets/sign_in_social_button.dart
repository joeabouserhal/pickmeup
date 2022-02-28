import 'package:flutter/material.dart';
import 'package:pickmeup/widgets/common_elevated_button.dart';

class SocialSignInButton extends CustomElevatedButton {
  SocialSignInButton({
    required String text,
    required Color color,
    required Color textColor,
    required String imageAssetName,
    required VoidCallback onPressed,
  }) : super(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(imageAssetName),
                Text(
                  text,
                  style: TextStyle(color: textColor, fontSize: 15),
                ),
                const SizedBox(
                  width: 30,
                  height: 30,
                ),
              ],
            ),
            color: color,
            onPressed: onPressed);
}
