import 'dart:convert';
import 'dart:io';



import '../model/animal.dart';
import '../model/person.dart';
import '../model/things.dart';

typedef SearchTerm = String;

class Api {
  List<Animal>? getAnimal;
  List<Person>? getPerson;
  Api();

  Future<List<Thing>> search(SearchTerm searchTerm) async {
    final term = searchTerm.trim().toLowerCase();
    final cachedResult = _extractThingUsingSearchTerm(term);
    if (cachedResult != null) {
      return cachedResult;
    }

    final person = await _getJson('http://127.0.0.1:5500/apis/persons.json')
        .then((json) => json.map((value) => Person.fromJson(value)));
    getPerson = person.toList();

    final animal = await _getJson('http://127.0.0.1:5500/apis/animals.json')
        .then((json) => json.map((value) => Animal.fromJson(value)));
    getAnimal = animal.toList();

    return _extractThingUsingSearchTerm(term) ?? [];
  }

  List<Thing>? _extractThingUsingSearchTerm(SearchTerm search) {
    final cachedAnimal = getAnimal;
    final cachedPerson = getPerson;
    if (cachedAnimal != null && cachedPerson != null) {
      List<Thing> result = [];
      for (final animal in cachedAnimal) {
        if (animal.name.trimmedContain(search) ||
            animal.type.name.trimmedContain(search)) {
          result.add(animal);
        }
      }
      for (final person in cachedPerson) {
        if (person.name.trimmedContain(search) ||
            person.age.toString().trimmedContain(search)) {
          result.add(person);
        }
      }
      return result;
    } else {
      return null;
    }
  }

  Future<List<dynamic>> _getJson(String url) => HttpClient()
      .getUrl(Uri.parse(url))
      .then((req) => req.close())
      .then((response) => response.transform(utf8.decoder).join())
      .then((jsonString) => jsonDecode(jsonString) as List<dynamic>);
}

extension TrimmedCaseInsensitiveContain on String {
  bool trimmedContain(String other) =>
      trim().toLowerCase().contains(other.trim().toLowerCase());
}
