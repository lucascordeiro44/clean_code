import 'dart:math';

import 'package:clean_code/core/error/exceptions.dart';
import 'package:clean_code/core/error/failures.dart';
import 'package:clean_code/core/network/network_info.dart';
import 'package:clean_code/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_code/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_code/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_code/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_code/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl? repository;
  MockLocalDataSource? mockLocalDataSource;
  MockRemoteDataSource? mockRemoteDataSource;
  MockNetworkInfo? mockNetworkInfo;

  setUpAll(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockLocalDataSource = MockLocalDataSource();
    repository = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource!,
        localDataSource: mockLocalDataSource!,
        networkInfo: mockNetworkInfo!);
  });

  group('getConcreteNumberTrivia', () {
    const double tNumber = 1;
    const NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'test Trivia');
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test(
      "should check if the device is online",
      () async {
        //arrange
        when(mockNetworkInfo?.isConnected).thenAnswer((_) async => true);
        //act
        await repository?.getConcreteNumberTrivia(tNumber.toInt());
        //assert
        verify(mockNetworkInfo!.isConnected);
      },
    );

    group('device is online getContreteNumberTrivia', () {
      setUp(() {
        when(mockNetworkInfo?.isConnected).thenAnswer((_) async => true);
      });
      test(
        "should return remote data when the call to remote data source is success",
        () async {
          //arrange
          when(mockRemoteDataSource?.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          //act
          final result =
              await repository?.getConcreteNumberTrivia(tNumber.toInt());
          //assert
          verify(
              mockRemoteDataSource?.getConcreteNumberTrivia(tNumber.toInt()));
          expect(result, equals(const Right(tNumberTrivia)));
        },
      );

      test(
        "should cache the data locally when the call to remote data source is success",
        () async {
          //arrange
          when(mockRemoteDataSource?.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          //act
          final result =
              await repository?.getConcreteNumberTrivia(tNumber.toInt());

          //assert
          verify(
              mockRemoteDataSource?.getConcreteNumberTrivia(tNumber.toInt()));
          verify(mockLocalDataSource?.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        "should return server failure when the call to remote data source is unsuccessful",
        () async {
          //arrange
          when(mockRemoteDataSource?.getConcreteNumberTrivia(any))
              .thenThrow(ServerException());
          //act
          final result =
              await repository?.getConcreteNumberTrivia(tNumber.toInt());
          //assert
          verify(
              mockRemoteDataSource?.getConcreteNumberTrivia(tNumber.toInt()));
          // verifyZeroInteractions(mockLocalDataSource);
          expect(result, left(ServerFailure()));
        },
      );
    });

    group('device is online getRandomNumberTrivia', () {
      setUp(() {
        when(mockNetworkInfo?.isConnected).thenAnswer((_) async => true);
      });
      test(
        "should return remote data when the call to remote data source is success",
        () async {
          //arrange
          when(mockRemoteDataSource?.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          //act
          final result = await repository?.getRandomNumberTrivia();
          //assert
          verify(mockRemoteDataSource?.getRandomNumberTrivia());
          expect(result, equals(const Right(tNumberTrivia)));
        },
      );

      test(
        "should cache the data locally when the call to remote data source is success",
        () async {
          //arrange
          when(mockRemoteDataSource?.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          //act
          final result = await repository?.getRandomNumberTrivia();

          //assert
          verify(mockRemoteDataSource?.getRandomNumberTrivia());
          verify(mockLocalDataSource?.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        "should return server failure when the call to remote data source is unsuccessful",
        () async {
          //arrange
          when(mockRemoteDataSource?.getRandomNumberTrivia())
              .thenThrow(ServerException());
          //act
          final result = await repository?.getRandomNumberTrivia();
          //assert
          verify(mockRemoteDataSource?.getRandomNumberTrivia());
          // verifyZeroInteractions(mockLocalDataSource);
          expect(result, left(ServerFailure()));
        },
      );
    });
    group('device is offline', () {
      setUp(() async {
        when(mockNetworkInfo?.isConnected).thenAnswer((_) async => false);
      });

      test(
        "should return last data locally when the connection is offline and ther cached data is present",
        () async {
          //arrange
          when(mockLocalDataSource?.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTrivia);
          //act
          final result =
              await repository?.getConcreteNumberTrivia(tNumber.toInt());
          //assert
          verify(mockLocalDataSource?.getLastNumberTrivia());
          expect(result, equals(right(tNumberTrivia)));
        },
      );

      test(
        "should return cache failure data locally cached data when there is no cached data present",
        () async {
          //arrange
          when(mockLocalDataSource?.getLastNumberTrivia())
              .thenThrow(CacheException());
          //act
          final result =
              await repository?.getConcreteNumberTrivia(tNumber.toInt());
          //assert
          verify(mockLocalDataSource?.getLastNumberTrivia());
          expect(result, equals(left(CacheFailure())));
        },
      );
    });
  });
}
