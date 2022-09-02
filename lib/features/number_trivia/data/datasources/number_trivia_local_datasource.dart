import 'dart:convert';

import 'package:clean_code/core/error/exceptions.dart';
import 'package:clean_code/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/number_trivia.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTrivia> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(dynamic triviaToCache);
}

const cachedNumberTrivia = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;
  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<NumberTrivia> getLastNumberTrivia() async {
    final jsonString = sharedPreferences.getString(cachedNumberTrivia);
    if (jsonString == null) {
      throw CacheException();
    }
    return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
  }

  @override
  Future<void> cacheNumberTrivia(dynamic triviaToCache) async {
    await sharedPreferences.setString(
        cachedNumberTrivia, json.encode(triviaToCache.toJson()));
  }
}
