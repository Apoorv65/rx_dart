import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rx_dart/chapter_11(Firebase)/dialogs/deleteContactDialog.dart';
import 'package:rx_dart/chapter_11(Firebase)/typeDefinition.dart';
import 'package:rx_dart/chapter_11(Firebase)/views/mainPopupMenuButton.dart';

import '../models/contact.dart';

class ContactListView extends StatelessWidget {
  final LogoutCallback logout;
  final DeleteContactCallback deleteContact;
  final DeleteAccountCallback deleteAccount;
  final VoidCallback createNewContact;
  final Stream<Iterable<Contact>> contacts;

  const ContactListView(
      {Key? key,
      required this.logout,
      required this.deleteContact,
      required this.deleteAccount,
      required this.createNewContact,
      required this.contacts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF9D342),
        title: Text(
          'Contact List',
          style: GoogleFonts.kumbhSans(color: const Color(0xff292826)),
        ),
        actions: [
          MainPopupMenuButton(logout: logout, deleteAccount: deleteAccount)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewContact,
        backgroundColor: const Color(0xffF9D342),
        child: const Icon(
          Icons.add,
          color: Color(0xff292826),
        ),
      ),
      body: StreamBuilder<Iterable<Contact>>(
        stream: contacts,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                  child: CircularProgressIndicator(color: Color(0xff292826)));
            case ConnectionState.done:
            case ConnectionState.active:
              final contacts = snapshot.requireData;
              return DelayedDisplay(
                delay: Duration(milliseconds: 1),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final contact = contacts.elementAt(index);
                    return ContactListTile(
                        contact: contact, deleteContact: deleteContact);
                  },
                  itemCount: contacts.length,
                ),
              );
          }
        },
      ),
    );
  }
}

class ContactListTile extends StatelessWidget {
  final Contact contact;
  final DeleteContactCallback deleteContact;

  const ContactListTile(
      {Key? key, required this.contact, required this.deleteContact})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        contact.fullName,
        style: GoogleFonts.kumbhSans(color: const Color(0xff292826)),
      ),
      trailing: IconButton(
          onPressed: () async {
            final shouldDelete = await showDeleteContactDialog(context);
            if (shouldDelete) {
              deleteContact(contact);
            }
          },
          icon: const Icon(Icons.delete_outline, color: Color(0xff292826))),
    );
  }
}
