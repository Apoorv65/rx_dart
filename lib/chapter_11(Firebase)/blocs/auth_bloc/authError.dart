import 'package:firebase_auth/firebase_auth.dart'show FirebaseAuthException;
import 'package:flutter/material.dart';

const Map<String, AuthError> authErrorMapping = {

  'user-not-found': AuthErrorUserNotFound(),
  'weak-password': AuthErrorWeakPassword(),
  'invalid-email': AuthErrorInvalidEmail(),
  'operation-not-allowed': AuthErrorOperationNotAllowed(),
  'email-already-in-use': AuthErrorEmailAlreadyInUse(),
  'requires-recent-login':AuthErrorRequiresRecentLogin(),
  'no-current-user':AuthErrorNoCurrentUser(),

};

@immutable
abstract class AuthError {
  final String dialogTitle;
  final String dialogText;

  const AuthError({
   required this.dialogTitle,
    required this.dialogText,
  });

  factory AuthError.form(FirebaseAuthException exception) =>

      authErrorMapping[exception.code.toLowerCase().trim()] ?? const AuthErrorUnknown();
}

@immutable
class AuthErrorUnknown extends AuthError {
   const AuthErrorUnknown():
      super(
        dialogTitle: 'Auth Error',
        dialogText: 'Unknown authentication error'
      );
}


@immutable
class AuthErrorNoCurrentUser extends AuthError {
  const AuthErrorNoCurrentUser():
        super(
          dialogTitle: 'No current user',
          dialogText: 'No current user with this information was available.'
      );
}

@immutable
class AuthErrorRequiresRecentLogin extends AuthError {
  const AuthErrorRequiresRecentLogin():
        super(
          dialogTitle: 'Requires recent login',
          dialogText: 'you need to re-login to perform this operation'
      );
}

@immutable
class AuthErrorOperationNotAllowed extends AuthError {
  const AuthErrorOperationNotAllowed():
        super(
          dialogTitle: 'Requires recent login',
          dialogText: 'you cannot register using this method at this moment!'
      );
}

@immutable
class AuthErrorUserNotFound extends AuthError {
  const AuthErrorUserNotFound():
        super(
          dialogTitle: 'User not found',
          dialogText: 'The given user is not found in the database'
      );
}

@immutable
class AuthErrorWeakPassword extends AuthError {
  const AuthErrorWeakPassword():
        super(
          dialogTitle: 'Weak Password',
          dialogText: 'Please choose a strong password consisting of more characters!'
      );
}

@immutable
class AuthErrorInvalidEmail extends AuthError {
  const AuthErrorInvalidEmail():
        super(
          dialogTitle: 'Invalid Email',
          dialogText: 'Please double check your email and try again!'
      );
}

@immutable
class AuthErrorEmailAlreadyInUse extends AuthError {
  const AuthErrorEmailAlreadyInUse():
        super(
          dialogTitle: 'Email already in use',
          dialogText: 'Please choose another email to register with!'
      );
}


/*
@immutable
class  extends AuthError {
  const ():
        super(
          dialogTitle: '',
          dialogText: ''
      );
}
*/