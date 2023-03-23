import 'package:flutter/foundation.dart';

import '../model/things.dart';
//state class

@immutable
abstract class SearchResult{
  const SearchResult();
}

@immutable
class SearchResultLoading implements SearchResult{
  const SearchResultLoading();
}

@immutable
class SearchResultNoResult implements SearchResult{
  const SearchResultNoResult();
}

@immutable
class SearchResultError implements SearchResult{
  final Object error;
  const SearchResultError(this.error);
}

@immutable
class SearchResultWithResult implements SearchResult{
  final List<Thing> results;
  const SearchResultWithResult(this.results);
}