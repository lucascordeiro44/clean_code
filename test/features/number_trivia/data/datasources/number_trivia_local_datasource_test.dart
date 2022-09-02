import 'dart:convert';

import 'package:clean_code/core/error/exceptions.dart';
import 'package:clean_code/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_code/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl? datasource;
  MockSharedPreferences? mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    datasource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences!);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
      "should return NumberTrivia from sharedPreferences when there is on in the cache",
      () async {
        //arrange
        when(mockSharedPreferences?.getString(cachedNumberTrivia))
            .thenReturn(fixture('trivia_cached.json'));
        //act
        final result = await datasource?.getLastNumberTrivia();
        //assert
        verify(mockSharedPreferences?.getString(cachedNumberTrivia));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      "should throw a CacheExeption when there is noto a ached value ",
      () async {
        //arrange
        when(mockSharedPreferences?.getString(cachedNumberTrivia))
            .thenReturn(null);
        //act
        final call = datasource?.getLastNumberTrivia;
        //assert
        verify(mockSharedPreferences?.getString(cachedNumberTrivia));
        expect(() async => await call!(), throwsA(isA<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: 1);

    test(
      "should call SharedPreferences to cache the data",
      () async {
        //act
        await datasource?.cacheNumberTrivia(tNumberTriviaModel);
        //assert
        final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
        verify(mockSharedPreferences?.setString(
            cachedNumberTrivia, expectedJsonString));
      },
    );
  });
}
