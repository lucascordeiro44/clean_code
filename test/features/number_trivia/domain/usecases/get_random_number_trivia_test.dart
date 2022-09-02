import 'package:clean_code/core/usecases/usecase.dart';
import 'package:clean_code/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_code/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks/mocks.dart';

void main() {
  GetRandomNumberTrivia? usecase;
  MockNumberTriviaRepository? mockNumberTriviaRepository;
  setUp(() {
    mockNumberTriviaRepository = mockNumberTriviaRep;
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository!);
  });

  final tNumberTrivia = NumberTrivia(text: "teste", number: 1);

  test(
    "Test get RandomNumber trivia",
    () async {
      //arrange
      when(mockNumberTriviaRepository?.getRandomNumberTrivia())
          .thenAnswer((_) async => Right(tNumberTrivia));
      //act
      final result = await usecase!(NoParams());
      //assert
    },
  );
}
