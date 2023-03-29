import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(const MyApp());
}

@immutable
class Bloc {
  final Sink<String?> setFirstName;
  final Sink<String?> setLastName;
  final Stream<String> fullName;

  const Bloc._({
    required this.setFirstName,
    required this.setLastName,
    required this.fullName,
  });

  void dispose() {
    setFirstName.close();
    setLastName.close();
  }

  factory Bloc() {
    final firstNameSubject = BehaviorSubject<String?>();
    final lastNameSubject = BehaviorSubject<String?>();

    final Stream<String> fullName = Rx.combineLatest2(
        firstNameSubject.startWith(null),
        lastNameSubject.startWith(null),
        (String? firstName, String? lastName) {
      if (firstName != null &&
          firstName.isNotEmpty &&
          lastName != null &&
          lastName.isNotEmpty) {
        return '$firstName $lastName';
      } else {
        return 'Both first and last names must be provided';
      }
    });
    return Bloc._(
      setFirstName: firstNameSubject.sink,
      setLastName: lastNameSubject.sink,
      fullName: fullName,
    );
  }
}

typedef AsyncSnapshotBuilderCallback<T> = Widget Function(
  BuildContext context,
  T? value,
);

class AsyncSnapshotBuilder<T> extends StatelessWidget {
  final Stream<T> stream;

  final AsyncSnapshotBuilderCallback<T>? onNone;
  final AsyncSnapshotBuilderCallback<T>? onWaiting;
  final AsyncSnapshotBuilderCallback<T>? onActive;
  final AsyncSnapshotBuilderCallback<T>? onDone;

  const AsyncSnapshotBuilder({
    super.key,
    required this.stream,
    this.onNone,
    this.onWaiting,
    this.onActive,
    this.onDone,

  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            final callback = onNone ?? (_, __) => const SizedBox();
            return callback(context, snapshot.data);
          case ConnectionState.waiting:
            final callback =
                onWaiting ?? (_, __) => const CircularProgressIndicator();
            return callback(context, snapshot.data);
          case ConnectionState.active:
            final callback = onActive ?? (_, __) => const SizedBox();
            return callback(context, snapshot.data);
          case ConnectionState.done:
            final callback = onDone ?? (_, __) => const SizedBox();
            return callback(context, snapshot.data);
        }
      },
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final Bloc bloc;
  @override
  void initState() {
    super.initState();
    bloc = Bloc();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple.shade200,
          title: const Text('CombineLatest with RxDart'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(
                      color: Colors.deepPurple.shade200,
                    ),
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextField(
                    onChanged: bloc.setFirstName.add,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'First Name',
                        hintStyle: GoogleFonts.kumbhSans()),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(
                      color: Colors.deepPurple.shade200,
                    ),
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextField(
                    onChanged: bloc.setLastName.add,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Last Name',
                        hintStyle: GoogleFonts.kumbhSans()),
                  ),
                ),
              ),
            ),
            AsyncSnapshotBuilder<String>(
              stream: bloc.fullName,
              onActive: (context, String? value) {
                return Text(value ?? '',style:GoogleFonts.kumbhSans(fontSize: 24),);
                
              },
            )
          ],
        ),
      ),
    );
  }
}
