import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/src/resources/repository.dart';

import '../lib/src/pages/homePage/bloc/bloc.dart';


class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final Repository repository;

  NewsBloc({this.repository});

  @override
  NewsState get initialState => Loading();

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    if (event is Fetch) {
      try {
        yield Loading();
        final items = await repository.fetchAllNews(category: event.type);
        yield Loaded(items: items, type: event.type);
        print("Test Passed");
      } catch (_) {
        yield Failure();
      }
    }
  }
}