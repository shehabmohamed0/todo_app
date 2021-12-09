import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/services/auth.dart';

class SignInBloc {
  final AuthBase auth;

  SignInBloc({required this.auth});

  final StreamController<bool> _isLoadingController = StreamController<bool>();

  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() => _isLoadingController.close();

  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User?> _signIn(Future<User?> Function() signInMethod) async {
    try {
      _setIsLoading(true);
      return await signInMethod();
    } on Exception catch (e) {
      _setIsLoading(false);
      rethrow;
    } finally {}
  }

  Future<User?> signInAnonymously() async =>
      await _signIn(() => auth.signInAnonymously());

  Future<User?> signWithGoogle() async => await auth.signWithGoogle();

  Future<User?> signInWithFacebook() async => await auth.signInWithFacebook();
}
