import 'package:flutter/material.dart';
import 'package:rx_dart/chapter_11(Firebase)/dialogs/generic_dialog.dart';

Future<bool> showDeleteContactDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: 'Delete Account',
      content:
          'Are you sure you want to delete this contact? This account can\'t be retrieved back.',
      optionsBuilder: () => {
            'Cancel': false,
            'Delete Account': true
          }).then((value) => value ?? false);
}
