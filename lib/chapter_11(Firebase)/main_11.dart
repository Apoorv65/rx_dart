import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rx_dart/chapter_11(Firebase)/Loading/loading_screen.dart';
import 'package:rx_dart/chapter_11(Firebase)/blocs/appBloc.dart';
import 'package:rx_dart/chapter_11(Firebase)/blocs/views_bloc/currentView.dart';
import 'package:rx_dart/chapter_11(Firebase)/dialogs/authErrorDialog.dart';
import 'package:rx_dart/chapter_11(Firebase)/views/contactListView.dart';
import 'package:rx_dart/chapter_11(Firebase)/views/loginView.dart';
import 'package:rx_dart/chapter_11(Firebase)/views/newContactView.dart';
import 'package:rx_dart/chapter_11(Firebase)/views/registerView.dart';

import '../firebase_options.dart';
import 'blocs/auth_bloc/authError.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AppBloc appBloc;
  StreamSubscription<AuthError?>? _authErrorSub;
  StreamSubscription<bool?>? _isLoadingSub;

  @override
  void initState() {
    super.initState();
    appBloc = AppBloc();
  }

  @override
  void dispose() {
    appBloc.dispose();
    _authErrorSub?.cancel();
    _isLoadingSub?.cancel();
    super.dispose();
  }

  void handleAuthErrors(BuildContext context) async {
    await _authErrorSub?.cancel();
    _authErrorSub = appBloc.authError.listen((event) {
      final AuthError? authError = event;
      if (authError == null) {
        return;
      }
      showAuthError(authError: authError, context: context);
    });
  }

  void setupLoadingScreen(BuildContext context) async {
    await _isLoadingSub?.cancel();
    _isLoadingSub = appBloc.isLoading.listen((isLoading) {
      if (isLoading) {
        LoadingScreen.instance().show(
          context: context,
          text: 'Loading...',
        );
      } else {
        LoadingScreen.instance().hide();
      }
    });
  }

  Widget getHomePage() {
    return StreamBuilder<CurrentView>(
      stream: appBloc.currentView,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(
                child: CircularProgressIndicator(color: Color(0xff292826)));
          case ConnectionState.active:
          case ConnectionState.done:
            final currentView = snapshot.requireData;
            switch (currentView) {
              case CurrentView.login:
                return LoginView(
                    login: appBloc.login,
                    goToRegisterView: appBloc.gotoRegisterView);
              case CurrentView.register:
                return RegisterView(
                    register: appBloc.register,
                    gotoLoginView: appBloc.gotoLoginView);
              case CurrentView.contactList:
                return ContactListView(
                  logout: appBloc.logout,
                  deleteAccount: appBloc.deleteAccount,
                  deleteContact: appBloc.deleteContact,
                  createNewContact: appBloc.gotoCreateContactView,
                  contacts: appBloc.contacts,
                );
              case CurrentView.createContact:
                return NewContactView(
                  createContact: appBloc.createContact,
                  goBack: appBloc.gotoContactListView,
                );
            }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    handleAuthErrors(context);
    setupLoadingScreen(context);
    return getHomePage();
  }
}
