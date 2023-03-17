import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

class Home extends HookWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //create our behavior subject every time widget is re-built
    final sub = useMemoized(
            () => BehaviorSubject<String>(),
        [key]
    );

    //dispose of the old subject every time widget is rebuild.
    useEffect(
            () => sub.close,
        [sub]
    );


    return Scaffold(
      appBar: AppBar(
        title:  StreamBuilder<String>(
          stream: sub.stream.distinct().debounceTime(const Duration(seconds: 1)),
          initialData: 'Please start typing...',
          builder: (context, snapshot) {
            return Text (snapshot.requireData);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: sub.sink.add,
            ),
          )
        ],)
    );
  }
}
