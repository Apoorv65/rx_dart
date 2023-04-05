import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rx_dart/chapter_11(Firebase)/dialogs/logoutDialog.dart';
import 'package:rx_dart/chapter_11(Firebase)/typeDefinition.dart';

import '../dialogs/deleteAccountDialog.dart';

enum MenuAction { logout, deleteAccount }

class MainPopupMenuButton extends StatelessWidget {
  final LogoutCallback logout;
  final DeleteAccountCallback deleteAccount;

  const MainPopupMenuButton(
      {Key? key, required this.logout, required this.deleteAccount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      icon: const Icon(Icons.more_vert_outlined,color: Color(0xff292826)),
      //color: const Color(0xff292826),
      onSelected: (value) async {
        switch (value) {
          case MenuAction.logout:
            final shouldLogout = await showLogoutDialog(context);
            if (shouldLogout) {
              logout();
            }
            break;
          case MenuAction.deleteAccount:
            final shouldDeleteAccount = await showDeleteAccountDialog(context);
            if (shouldDeleteAccount) {
              deleteAccount();
            }
            break;
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem<MenuAction>(
            value: MenuAction.logout,
            child: Text(
              'Logout',
              style: GoogleFonts.kumbhSans(color: const Color(0xff292826)),
            ),
          ),
          PopupMenuItem<MenuAction>(
            value: MenuAction.deleteAccount,
            child: Text(
              'Delete Account',
              style: GoogleFonts.kumbhSans(color: const Color(0xff292826)),
            ),
          )
        ];
      },
    );
  }
}
