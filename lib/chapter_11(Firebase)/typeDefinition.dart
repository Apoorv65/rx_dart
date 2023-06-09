import 'package:flutter/material.dart';

import 'models/contact.dart';

typedef LogoutCallback = VoidCallback;
typedef GoBackCallback = VoidCallback;
typedef DeleteAccountCallback = VoidCallback;

typedef LoginFunc = void Function(String email, String password);
typedef RegisterFunc = void Function(String email, String password);
typedef CreateContactCallback = void Function(String firstName, String lastName, String phoneNumber);
typedef DeleteContactCallback = void Function(Contact contact);