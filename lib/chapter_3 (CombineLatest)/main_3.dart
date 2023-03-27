import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(const MyApp());
}

void testIt() async {
  final _stream1 = Stream.periodic(
      const Duration(seconds: 1), (count) => 'Stream 1 & count is :$count');

  final _stream2 = Stream.periodic(
      const Duration(seconds: 3), (count) => 'Stream 2 & count is :$count');

  final combined =
      Rx.combineLatest2(_stream1, _stream2, (a, b) => 'a = ($a) & b = ($b)');

  await for (final value in combined) {
    value.log();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    testIt();
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(),
    );
  }
}
