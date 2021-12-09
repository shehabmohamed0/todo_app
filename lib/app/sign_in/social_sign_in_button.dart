import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/common_widgets/custom_elevated_button.dart';

class SocialSignInButton extends CustomElevatedButton {
  SocialSignInButton(
      {required String text,
      required String assetName,
      required Color color,
      required Color colorOnButton,
      required VoidCallback onPress})
      : super(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: EdgeInsets.all(6), child: Image.asset(assetName)),
                Text(
                  'Sign in with Google',
                  style: TextStyle(fontSize: 18),
                ),
                Opacity(
                  opacity: 0,
                  child: Image.asset(assetName),
                ),
              ],
            ),
            height: 50,
            color: color,
            colorOnButton: colorOnButton,
            onPress: onPress);
}
