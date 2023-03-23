import 'package:flutter/material.dart';
import 'package:rx_dart/chapter_2(Search)/views/search.dart';

import '../bloc/Search_bloc.dart';
import '../bloc/api.dart';

class HomeChap2 extends StatefulWidget {
  const HomeChap2({Key? key}) : super(key: key);

  @override
  State<HomeChap2> createState() => _HomeChap2State();
}

class _HomeChap2State extends State<HomeChap2> {
  late final SearchBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = SearchBloc(api: Api());
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Enter search term'
            ),
            onChanged: _bloc.search.add,
          ),
          const SizedBox(height: 10),
        SearchView(searchResult: _bloc.results)
        ]),
      ),
    );
  }
}
