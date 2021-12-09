import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  late final Widget child;
  late final Color color;
  final double? height;
  late final Color colorOnButton;
  final double? borderRadius;
  late final VoidCallback onPress;

  CustomElevatedButton(
      {required this.child,
      required this.color,
      required this.colorOnButton,
      this.borderRadius: 5,
      this.height: 50,
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: onPress,
        child: child,
        style: ElevatedButton.styleFrom(
          primary: color,
          onPrimary: colorOnButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius!),
            ),
          ),
        ),
      ),
    );
  }
}
