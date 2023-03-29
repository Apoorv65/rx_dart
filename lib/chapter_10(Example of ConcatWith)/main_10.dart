import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

Stream<String> getName({
  required String filePath,
}) {
  final names = rootBundle.loadString(filePath);
  return Stream.fromFuture(names).transform(const LineSplitter());
}

Stream<String> getAllNames() => getName(filePath: 'assets/texts/cats.txt')
    .concatWith([getName(filePath: 'assets/texts/dogs.txt')]).delay(const Duration(seconds: 2));

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple.shade200,
          title: const Text('ConcatWith with RxDart'),
        ),
        body: FutureBuilder<List<String>>(
          future: getAllNames().toList(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return Center(child: CircularProgressIndicator(color: Colors.deepPurple.shade200,));
              case ConnectionState.done:
                final names = snapshot.requireData;
                return ListView.separated(
                  itemCount: names.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(names[index],style:GoogleFonts.kumbhSans(fontSize: 24),),
                    );
                  },
                  separatorBuilder: (_, __) =>
                      const Divider(color: Colors.black),
                );
            }
          },
        ),
      ),
    );
  }
}
