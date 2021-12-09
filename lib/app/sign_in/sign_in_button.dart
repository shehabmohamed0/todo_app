import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/common_widgets/custom_elevated_button.dart';

class SignInButton extends CustomElevatedButton {
  SignInButton(
      {required String text,
      required Color color,
      required Color colorOnButton,
      double? borderRadius: 2,
      required VoidCallback onPress})
      : super(
            child: Text(
              text,
              style: TextStyle(fontSize: 18),
            ),
            height: 50,
            color: color,
            colorOnButton: colorOnButton,
            borderRadius: borderRadius,
            onPress: onPress);
}
