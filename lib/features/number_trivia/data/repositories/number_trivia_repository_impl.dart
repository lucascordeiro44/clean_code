import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/number_trivia_local_datasource.dart';
import '../datasources/number_trivia_remote_datasource.dart';
import '../../domain/entities/number_trivia.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/number_triva_repository.dart';
import 'package:dartz/dartz.dart';

typedef _ConcreteOrRandomChooser = Future<NumberTrivia> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int? number) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  Map<int, String> map = {1: "n"};
  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  //High order function
  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _ConcreteOrRandomChooser call) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await call();
        await localDataSource.cacheNumberTrivia(result);
        return right(result);
      } on ServerException catch (e) {
        return left(ServerFailure());
      }
    } else {
      try {
        final result = await localDataSource.getLastNumberTrivia();
        return right(result);
      } on CacheException catch (e) {
        return left(CacheFailure());
      }
    }
  }
}
