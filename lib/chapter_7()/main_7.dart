import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';

import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final BehaviorSubject<DateTime> subject;
  late final Stream<String> streamOfString;

  @override
  void initState() {
    super.initState();
    subject = BehaviorSubject<DateTime>();
    streamOfString = subject.switchMap((dateTime) => Stream.periodic(
        const Duration(seconds: 1),
            (count) => 'Stream count is $count, Date Time is $dateTime'));
  }

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<String>(
                  stream: streamOfString,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final string = snapshot.requireData;
                      return DelayedDisplay(
                          child: Text(string,
                              style: GoogleFonts.meowScript(
                                  fontSize: 30, color: Colors.deepPurple)));
                    } else {
                      return const Text('Waiting for the button to be pressed',
                          style: TextStyle(color: Colors.white)
                         );
                    }
                  }),
              ElevatedButton(style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.deepPurple)),
                  onPressed: () {
                    subject.add(DateTime.now());
                  },
                  child: Text('Tap',))
            ],
          ),
        ),
      ),
    );
  }
}
