import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rx_dart/chapter_11(Firebase)/blocs/auth_bloc/authBloc.dart';
import 'package:rx_dart/chapter_11(Firebase)/blocs/contactsBloc.dart';
import 'package:rx_dart/chapter_11(Firebase)/blocs/views_bloc/currentView.dart';
import 'package:rx_dart/chapter_11(Firebase)/blocs/views_bloc/viewBloc.dart';
import 'package:rxdart/rxdart.dart';

import '../models/contact.dart';
import 'auth_bloc/authError.dart';

@immutable
class AppBloc {
  final AuthBloc _authBloc;
  final ViewsBloc _viewsBloc;
  final ContactsBloc _contactsBloc;

  final Stream<CurrentView> currentView;
  final Stream<bool> isLoading;
  final Stream<AuthError?> authError;
  final StreamSubscription<String?> _userIdChanges;

  factory AppBloc() {
    final authBloc = AuthBloc();
    final viewsBloc = ViewsBloc();
    final contactsBloc = ContactsBloc();

    final userIdChanges = authBloc.userId.listen((String? userId) {
      contactsBloc.userId.add(userId);
    });

    final Stream<CurrentView> currentViewBasedOnAuthStatus =
        authBloc.authStatus.map<CurrentView>((authStatus) {
      if (authStatus is AuthStatusLoggedIn) {
        return CurrentView.contactList;
      } else {
        return CurrentView.login;
      }
    });

    final Stream<CurrentView> currentView =
        Rx.merge([currentViewBasedOnAuthStatus, viewsBloc.currentView]);

    final Stream<bool> isLoading = Rx.merge([authBloc.isLoading]);

    return AppBloc._(
      authBloc: authBloc,
      viewsBloc: viewsBloc,
      contactsBloc: contactsBloc,
      currentView: currentView,
      isLoading: isLoading.asBroadcastStream(),
      authError: authBloc.authError.asBroadcastStream(),
      userIdChanges: userIdChanges,
    );
  }

  void dispose() {
    _authBloc.dispose();
    _viewsBloc.dispose();
    _contactsBloc.dispose();
    _userIdChanges.cancel();
  }

  const AppBloc._({
    required AuthBloc authBloc,
    required ViewsBloc viewsBloc,
    required ContactsBloc contactsBloc,
    required this.currentView,
    required this.isLoading,
    required this.authError,
    required StreamSubscription<String?> userIdChanges,
  })  : _authBloc = authBloc,
        _viewsBloc = viewsBloc,
        _contactsBloc = contactsBloc,
        _userIdChanges = userIdChanges;

  void deleteContact(Contact contact) {
    _contactsBloc.deleteContact.add(contact);
  }

  void createContact(
    String firstName,
    String lastName,
    String phoneNumber,
  ) {
    _contactsBloc.createContact.add(Contact.withoutId(
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
    ));
  }

  void deleteAccount() {
    //print("Deleting");
    _contactsBloc.deleteAllContact.add(null);
    _authBloc.deleteAccount.add(null);
  }

  void logout() {
    _authBloc.logout.add(null);
  }

  Stream<Iterable<Contact>> get contacts => _contactsBloc.contacts;

  void register(
    String email,
    String password,
  ) {
    _authBloc.register.add(RegisterCommand(email: email, password: password));
  }

  void login(
    String email,
    String password,
  ) {
    _authBloc.login.add(LoginCommand(email: email, password: password));
  }

  void gotoContactListView() =>
      _viewsBloc.goToView.add(CurrentView.contactList);

  void gotoCreateContactView() =>
      _viewsBloc.goToView.add(CurrentView.createContact);

  void gotoRegisterView() =>
      _viewsBloc.goToView.add(CurrentView.register);

  void gotoLoginView() =>
      _viewsBloc.goToView.add(CurrentView.login);
}
