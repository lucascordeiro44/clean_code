import 'dart:math';

import 'package:clean_code/core/error/failures.dart';
import 'package:clean_code/core/presentatiion/util/input_converter.dart';
import 'package:clean_code/core/usecases/usecase.dart';
import 'package:clean_code/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_code/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_code/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_code/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../data/datasources/number_trivia_remote_datasource_test.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  MockGetConcreteNumberTrivia? mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia? mockGetRandomNumberTrivia;
  MockInputConverter? mockInputConverter;
  NumberTriviaBloc? bloc;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia!,
        getRandomNumberTrivia: mockGetRandomNumberTrivia!,
        inputConverter: mockInputConverter!);
  });

  final tNumberString = '1';
  final tNumberParsed = 1;
  final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');
  final tRandomNumberTrivia =
      NumberTrivia(number: 248, text: 'test Random trivia');
  test("initialState should be Empty", () async {
    //assert
    expect(bloc?.state, Empty());
  });

  group('getTriviaForConcreteNumber', () {
    test(
      "should call the InputConverter to validate and convert the string to an unsigned integer",
      () async {
        //arrange
        when(mockInputConverter?.stringToUnsignedInteger('1'))
            .thenReturn(right(tNumberParsed));
        when(mockGetConcreteNumberTrivia?.call(Params(number: tNumber)))
            .thenAnswer((_) async => right(tNumberTrivia));
        //act
        bloc?.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(
            mockInputConverter?.stringToUnsignedInteger(tNumberString));
        //assert
        verify(mockInputConverter?.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      "should emit [Error] when the input is invalid",
      () async {
        //arrange
        when(mockInputConverter?.stringToUnsignedInteger(tNumberString))
            .thenReturn(left(InvalidInputFailure()));

        //act
        bloc?.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(
            mockInputConverter?.stringToUnsignedInteger(tNumberString));
        //assert later
        expectLater(bloc?.state, const Error(message: INVALID_ERROR_MESSAGE));
      },
    );

    test(
      "should get data emit [Loading(), Loaded()] from the concrete use case",
      () async {
        //arrange
        when(mockInputConverter?.stringToUnsignedInteger(tNumberString))
            .thenReturn(right(tNumberParsed));
        when(mockGetConcreteNumberTrivia?.call(Params(number: tNumber)))
            .thenAnswer((_) async => right(tNumberTrivia));
        //act
        bloc?.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(
            mockInputConverter?.stringToUnsignedInteger(tNumberString));
        await untilCalled(
            mockGetConcreteNumberTrivia?.call(Params(number: tNumber)));
        //assert
        expectLater(bloc?.state, Loaded(numberTrivia: tNumberTrivia));
      },
    );

    test(
      "should emit [Loading, Error] when getting data fails",
      () async {
        //arrange
        when(mockInputConverter?.stringToUnsignedInteger(tNumberString))
            .thenReturn(right(tNumberParsed));
        when(mockGetConcreteNumberTrivia?.call(Params(number: tNumber)))
            .thenAnswer((_) async => left(ServerFailure()));
        //act
        bloc?.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(
            mockInputConverter?.stringToUnsignedInteger(tNumberString));
        await untilCalled(
            mockGetConcreteNumberTrivia?.call(Params(number: tNumber)));
        //assert
        expectLater(bloc?.state, const Error(message: SERVER_ERROR_MESSAGE));
      },
    );
  });

  group('getTriviaForRandomNumber', () {
    test(
      "should get data from the emit [Loading(), Loaded()] random use case",
      () async {
        //arrange
        when(mockGetRandomNumberTrivia?.call(NoParams()))
            .thenAnswer((_) async => right(tRandomNumberTrivia));
        //act
        bloc?.add(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia?.call(NoParams()));
        await untilCalled(mockGetRandomNumberTrivia?.call(NoParams()));
        //assert
        expectLater(bloc?.state, Loaded(numberTrivia: tRandomNumberTrivia));
      },
    );

    test(
      "should emit [Loading, Error] when getting data fails",
      () async {
        //arrange
        when(mockGetRandomNumberTrivia?.call(NoParams()))
            .thenAnswer((_) async => left(ServerFailure()));
        //act

        bloc?.add(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia?.call(NoParams()));
        await untilCalled(mockGetRandomNumberTrivia?.call(NoParams()));
        //assert
        expectLater(bloc?.state, const Error(message: SERVER_ERROR_MESSAGE));
      },
    );
  });
}
