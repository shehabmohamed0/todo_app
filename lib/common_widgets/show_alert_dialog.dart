import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool?> showAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  String? cancelActionText,
  required String defaultActionText,
}) async {
  if (!Platform.isIOS) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          if (cancelActionText != null)
            TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(cancelActionText)),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(defaultActionText))
        ],
      ),
    );
  }
  return showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(defaultActionText),
              )
            ],
          ));
}
