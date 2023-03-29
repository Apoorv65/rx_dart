import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(const MyApp());
}

enum TypeOfThing { animal, person }

@immutable
class Thing {
  final TypeOfThing type;
  final String name;

  const Thing({
    required this.type,
    required this.name,
  });
}

@immutable
class Bloc {
  final Sink<TypeOfThing?> setTypeofThing;
  final Stream<TypeOfThing?> currentTypeofThing;
  final Stream<Iterable<Thing>> things;

  const Bloc._({
    required this.setTypeofThing,
    required this.currentTypeofThing,
    required this.things,
  });

  void dispose() {
    setTypeofThing.close();
  }

  factory Bloc({
    required Iterable<Thing> things,
  }) {
    final typeofThingSubject = BehaviorSubject<TypeOfThing?>();
    final filteredThings = typeofThingSubject
        .debounceTime(const Duration(milliseconds: 100))
        .map<Iterable<Thing>>((typeofThing) {
      if (typeofThing != null) {
        return things.where((things) => things.type == typeofThing);
      } else {
        return things;
      }
    }).startWith(things);

    return Bloc._(
      setTypeofThing: typeofThingSubject.sink,
      currentTypeofThing: typeofThingSubject.stream,
      things: filteredThings,
    );
  }
}

const things = [
  Thing(type: TypeOfThing.person, name: 'Foo'),
  Thing(type: TypeOfThing.person, name: 'Bar'),
  Thing(type: TypeOfThing.person, name: 'Baz'),
  Thing(type: TypeOfThing.animal, name: 'Bunz'),
  Thing(type: TypeOfThing.animal, name: 'Fluffers'),
  Thing(type: TypeOfThing.animal, name: 'Woofz'),
];

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
    bloc = Bloc(
      things: things,
    );
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
          title: const Text('FilterChip with RxDart'),
        ),
        body: Column(children: [
          StreamBuilder<TypeOfThing?>(
              stream: bloc.currentTypeofThing,
              builder: (context, snapshot) {
                final selectedTypeOfThings = snapshot.data;
                return Wrap(
                  children: TypeOfThing.values.map((typeOfThing) {
                    return FilterChip(
                      showCheckmark: false,
                      selectedColor: Colors.deepPurple.shade50,
                      onSelected: (selected) {
                        final type = selected ? typeOfThing : null;
                        bloc.setTypeofThing.add(type);
                      },
                      label: Text(typeOfThing.name),
                      selected: selectedTypeOfThings == typeOfThing,
                    );
                  }).toList(),
                );
              }),
          Expanded(
              child: StreamBuilder<Iterable<Thing>>(
            stream: bloc.things,
            builder: (context, snapshot) {
              final things = snapshot.data ?? [];
              return ListView.builder(
                  itemCount: things.length,
                  itemBuilder: (context, snapshot) {
                    final thing = things.elementAt(snapshot);
                    return ListTile(
                      title: Text(thing.name),
                      subtitle: Text(thing.type.name),
                    );
                  });
            },
          ))
        ]),
      ),
    );
  }
}
