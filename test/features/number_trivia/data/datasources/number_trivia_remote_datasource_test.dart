import 'dart:convert';

import 'package:clean_code/core/error/exceptions.dart';
import 'package:clean_code/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_code/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

const tNumber = 1;
final tNumberTriviaModel =
    NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
void main() {
  NumberTriviaRemoteDataSourceImpl? datasource;
  MockHttpClient? mockHttpClient;
  setUpAll(() {
    mockHttpClient = MockHttpClient();
    datasource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient!);
  });

  void mockHttpSucess() {
    when(mockHttpClient?.get(Uri.parse('http://numbersapi.com/$tNumber'),
            headers: {'Content-Type': 'application/json'}))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void mockHttpFailure() {
    when(mockHttpClient?.get(Uri.parse('http://numbersapi.com/$tNumber'),
            headers: {'Content-Type': 'application/json'}))
        .thenThrow(() => throw ServerException());
  }

  group('getConcreteNumberTrivia', () {
    test(
      '''should perform a GET request on a URL with number being the endpoint 
      and with application/json header''',
      () async {
        //arrange
        mockHttpSucess();
        //act
        final result = await datasource?.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockHttpClient?.get(Uri.parse('http://numbersapi.com/$tNumber'),
            headers: {'Content-Type': 'application/json'}));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      "should throw a ServerException when the response code is 404 or other",
      () async {
        //arrange
        mockHttpFailure();
        //act
        final call = datasource?.getConcreteNumberTrivia;
        //assert
        expect(
            () async => await call!(tNumber), throwsA(isA<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    test(
      '''should perform a GET request on a URL with number being the endpoint 
      and with application/json header''',
      () async {
        //arrange
        when(mockHttpClient
            ?.get(Uri.parse('http://numbersapi.com/random'), headers: {
          'Content-Type': 'application/json'
        })).thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
        //act
        final result = await datasource?.getRandomNumberTrivia();
        //assert
        verify(mockHttpClient?.get(Uri.parse('http://numbersapi.com/random'),
            headers: {'Content-Type': 'application/json'}));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      "should throw a ServerException when the response code is 404 or other",
      () async {
        //arrange
        when(mockHttpClient?.get(Uri.parse('http://numbersapi.com/random'),
                headers: {'Content-Type': 'application/json'}))
            .thenThrow(() => throw ServerException());
        //act
        final call = datasource?.getRandomNumberTrivia;
        //assert
        expect(() async => await call!(), throwsA(isA<ServerException>()));
      },
    );
  });
}
