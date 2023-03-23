import 'dart:async';

import 'package:flutter/material.dart';

import '../bloc/search_result.dart';
import '../model/animal.dart';
import '../model/person.dart';

class SearchView extends StatelessWidget {
  final Stream<SearchResult?> searchResult;
  const SearchView({Key? key, required this.searchResult}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SearchResult?>(
        stream: searchResult,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final result = snapshot.data;
            if (result is SearchResultError) {
              return const Text('Got data error');
            } else if (result is SearchResultLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (result is SearchResultNoResult) {
              return const Text(
                  'No result found in the search result collection.');
            } else if (result is SearchResultWithResult) {
              final results = result.results;
              return Expanded(
                  child: ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final item = results[index];
                        final String title;
                        if (item is Animal){
                          title ='Animal';
                        }else if (item is Person){
                          title ='Person';
                        }else{
                          title ='Unknown';
                        }
                        return ListTile(
                          title: Text(title),
                          subtitle: Text(item.toString()),
                        );
                      }));
            }else{
              return const Text('Unknown result');
            }
          } else {
            return const Text('waiting');
          }
        });
  }
}

















