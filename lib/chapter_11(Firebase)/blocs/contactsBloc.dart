import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../models/contact.dart';

typedef _Snapshots = QuerySnapshot<Map<String, dynamic>>;
//typedef _Document = DocumentReference<Map<String, dynamic>>;

extension Unwrap<T> on Stream<T?> {
  Stream<T> unwrap() => switchMap((optional) async* {
        if (optional != null) {
          yield optional;
        }
      });
}

@immutable
class ContactsBloc {
  final Sink<String?> userId;
  final Sink<Contact> createContact;
  final Sink<Contact> deleteContact;
  final Sink<void> deleteAllContact;
  final Stream<Iterable<Contact>> contacts;
  final StreamSubscription<void> _createContactSubscription;
  final StreamSubscription<void> _deleteContactSubscription;
  final StreamSubscription<void> _deleteAllContactSubscription;

  void dispose() {
    userId.close();
    createContact.close();
    deleteContact.close();
    deleteAllContact.close();
    _deleteContactSubscription.cancel();
    _deleteAllContactSubscription.cancel();
    _createContactSubscription.cancel();
  }

  const ContactsBloc._({
    required this.userId,
    required this.createContact,
    required this.deleteContact,
    required this.deleteAllContact,
    required this.contacts,
    required StreamSubscription<void> createContactSubscription,
    required StreamSubscription<void> deleteContactSubscription,
    required StreamSubscription<void> deleteAllContactSubscription,
  })  : _createContactSubscription = createContactSubscription,
        _deleteContactSubscription = deleteContactSubscription,
        _deleteAllContactSubscription = deleteAllContactSubscription;

  factory ContactsBloc() {
    final backend = FirebaseFirestore.instance;

    final userId = BehaviorSubject<String?>();

    final Stream<Iterable<Contact>> contacts = userId.switchMap((userId) {
      if (userId == null) {
        return const Stream<_Snapshots>.empty();
      } else {
        return backend.collection(userId).snapshots();
      }
    }).map<Iterable<Contact>>((snapshots) sync* {
      for (final doc in snapshots.docs) {
        yield Contact.fromJSON(doc.data(), id: doc.id);
      }
    });

    //create a new Contact
    final createContact = BehaviorSubject<Contact>();
    final StreamSubscription<void> createContactSubscription = createContact
        .switchMap((contactToCreate) => userId.take(1).unwrap().asyncMap(
              (userId) => backend.collection(userId).add(contactToCreate.data),
            ))
        .listen((event) {});

    //delete Contact
    final deleteContact = BehaviorSubject<Contact>();
    final StreamSubscription<void> deleteContactSubscription = deleteContact
        .switchMap((contactToDelete) => userId.take(1).unwrap().asyncMap(
              (userId) =>
                  backend.collection(userId).doc(contactToDelete.id).delete(),
            ))
        .listen((event) {});

    //delete All Contact
    final deleteAllContact = BehaviorSubject<void>();
    final StreamSubscription<void> deleteAllContactSubscription =
        deleteAllContact
            .switchMap((_) => userId
                .take(1)
                .unwrap()
                .asyncMap((userId) => backend.collection(userId).get())
                .switchMap((collection) => Stream.fromFutures(
                    collection.docs.map((doc) => doc.reference.delete()))))
            .listen((event) {});

    //create ContactBloc
    return ContactsBloc._(
      userId: userId,
      createContact: createContact,
      deleteContact: deleteContact,
      contacts: contacts,
      createContactSubscription: createContactSubscription,
      deleteContactSubscription: deleteContactSubscription,
      deleteAllContactSubscription: deleteAllContactSubscription,
      deleteAllContact: deleteAllContact,
    );
  }
}
