import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app/common_widgets/show_alert_dialog.dart';

class ShowExceptionAletDialog {}

Future<void> showExceptionAlertDialog(
  BuildContext context, {
  required String title,
  required Exception exception,
}) =>
    showAlertDialog(
        context: context,
        title: title,
        content: _message(exception),
        defaultActionText: 'OK');
String _message(Exception exception) {
  if (exception is FirebaseAuthException) {
    return exception.message!;
  }
  return exception.toString();
}
