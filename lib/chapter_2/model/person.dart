import 'package:flutter/foundation.dart';
import 'package:rx_dart/chapter_2/model/things.dart';

@immutable
class Person extends Thing {
  final int age;

  const Person({required String name, required this.age}) : super(name: name);

  @override
  String toString() => 'Person, name : $name, type : $age';

  Person.fromJson(Map<String, dynamic>json)
      :age = json["age"] as int,
        super(name: json["name"] as String);

}