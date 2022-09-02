import 'package:clean_code/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_code/features/number_trivia/domain/repositories/number_triva_repository.dart';
import 'package:clean_code/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks/mocks.dart';

void main() {
  GetConcreteNumberTrivia? usecase;
  MockNumberTriviaRepository? mockNumberTriviaRepository;
  setUp(() {
    mockNumberTriviaRepository = mockNumberTriviaRep;
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository!);
  });

  int tNumber = 1;
  final tNumberTrivia = NumberTrivia(text: 'text', number: 1);

  test(
    "should get trivia for the number from the repository",
    () async {
      //arrange
      when(mockNumberTriviaRepository?.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      //act
      final result = await usecase!(Params(number: tNumber));
      //assert
      expectLater(result, Right(tNumberTrivia));
      verify(mockNumberTriviaRepository?.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository!);
    },
  );
}
