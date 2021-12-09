import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app/sign_in/email_sign_in_page.dart';
import 'package:todo_app/app/sign_in_manager/sign_in_manager.dart';
import 'package:todo_app/app/sign_in/sign_in_button.dart';
import 'package:todo_app/app/sign_in/social_sign_in_button.dart';
import 'package:todo_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:todo_app/services/auth.dart';

class SignInPage extends StatelessWidget {
  final SignInManager manager;

  SignInPage({required this.manager});

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (_, bloc, __) {
              return SignInPage(manager: bloc);
            },
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseAuthException &&
        exception.code == 'ERROR_ABORTED_BY_USER') return;
    showExceptionAlertDialog(context,
        title: 'Sign in failed', exception: exception);
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signWithGoogle();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await manager.signInWithFacebook();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  void _signInWithEmail(BuildContext context) {
    // TODO:ShowEmailSignInPage
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) => EmailSignInPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<ValueNotifier<bool>>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Time Tracker'), elevation: 2),
      backgroundColor: Colors.grey[200],
      body: _buildContent(context, isLoading.value),
    );
  }

  Padding _buildContent(BuildContext context, bool isLoading) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(isLoading),
          SizedBox(
            height: 48,
          ),
          SocialSignInButton(
              text: 'Sign in with Google',
              assetName: 'assets/logos/google.png',
              color: Colors.white,
              colorOnButton: Colors.black,
              onPress: () => isLoading ? null : _signInWithGoogle(context)),
          SizedBox(
            height: 8,
          ),
          SocialSignInButton(
              text: 'Sign in with Facebook',
              assetName: 'assets/logos/facebook.png',
              color: Color(0xFF334D92),
              colorOnButton: Colors.white,
              onPress: () => isLoading ? null : _signInWithFacebook(context)),
          SizedBox(
            height: 8,
          ),
          SignInButton(
            text: 'Sign in with email',
            color: Colors.teal[700]!,
            colorOnButton: Colors.white,
            onPress: () => isLoading ? null : _signInWithEmail(context),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'or',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          SignInButton(
            text: 'Go anonymous',
            color: Colors.lime[300]!,
            colorOnButton: Colors.black,
            onPress: () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isLoading) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'Sign in',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
    );
  }
}
