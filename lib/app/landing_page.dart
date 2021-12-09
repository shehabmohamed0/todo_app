import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app/home/home_page.dart';
import 'package:todo_app/app/home/jobs/jobs_page.dart';
import 'package:todo_app/app/sign_in_manager/sign_in_page_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/services/auth.dart';
import 'package:todo_app/services/data_base.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return SignInPage.create(context);
          }
          return Provider<Database>(
              create: (_) => FireStoreDataBase(uid: user.uid),
              child: HomePage());
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
