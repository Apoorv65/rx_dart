import 'package:flutter/cupertino.dart';
import 'package:rx_dart/chapter_11(Firebase)/blocs/auth_bloc/authError.dart';
import 'package:rx_dart/chapter_11(Firebase)/dialogs/generic_dialog.dart';

Future<void> showAuthError({
  required AuthError authError,
  required BuildContext context,
}) =>
  showGenericDialog(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogText,
    optionsBuilder: () => {'OK': true},
  );

