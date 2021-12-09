import 'dart:async';

import 'package:todo_app/app/sign_in/email_sign_in_model.dart';
import 'package:todo_app/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({required this.auth});

  final AuthBase auth;
  final StreamController<EmailSignInModel> _modelController =
      StreamController();

  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel();

  void dispose() {
    _modelController.close();
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(
            _model.email, _model.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void toggleFormType() {
    final formType = _model.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      forType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateWith(
      {String? email,
      String? password,
      EmailSignInFormType? forType,
      bool? isLoading,
      bool? submitted}) {
    //update model
    _model = _model.copyWith(
        email: email,
        password: password,
        formType: forType,
        isLoading: isLoading,
        submitted: submitted);

    //add updatedModel to _modelController
    _modelController.add(_model);
  }
}
