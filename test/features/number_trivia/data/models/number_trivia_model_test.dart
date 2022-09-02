import 'dart:convert';

import 'package:clean_code/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_code/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test Text");
  test('should be a subclass of NumberTrivia Entity', () async {
    expect((tNumberTriviaModel), isA<NumberTrivia>());
  });

  group('Test fromJson', () {
    test(
      "should return a valid model when the JSON number is an integer",
      () async {
        //arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia.json'));
        //acts
        final result = NumberTriviaModel.fromJson(jsonMap);
        //assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      "should return a valid model when the JSON number is regarded as a double",
      () async {
        //arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia_double.json'));
        //acts
        final result = NumberTriviaModel.fromJson(jsonMap);
        //assert
        expect(result, equals(tNumberTriviaModel));
      },
    );
  });

  group('Test toJson', () {
    test(
      "should return a JSON map containing the proper data",
      () async {
        //arrange
        final expectedMap = {
          'text': "Test Text",
          'number': 1,
        };
        //act
        final result = tNumberTriviaModel.toJson();
        //assert
        expect(result, equals(expectedMap));
      },
    );
  });
}
