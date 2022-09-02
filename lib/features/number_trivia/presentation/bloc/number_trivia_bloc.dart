import 'package:bloc/bloc.dart';
import 'package:clean_code/core/error/failures.dart';
import 'package:clean_code/core/presentatiion/util/input_converter.dart';
import 'package:clean_code/core/usecases/usecase.dart';
import 'package:clean_code/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_code/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_code/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const INVALID_ERROR_MESSAGE = 'Invalid Input ERROR';
const SERVER_ERROR_MESSAGE = 'Server ERROR';
const CACHE_ERROR_MESSAGE = 'CACHE ERROR';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;
  NumberTriviaBloc(
      {required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter})
      : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) async {
      if (event is GetTriviaForConcreteNumber) {
        emit(Loading());
        final inputEither =
            inputConverter.stringToUnsignedInteger(event.numberString);
        inputEither.fold((l) {
          emit(const Error(message: INVALID_ERROR_MESSAGE));
        }, (r) async {
          final param = Params(number: r);
          final result = await getConcreteNumberTrivia.call(param);
          result.fold(
              (l) => emit(Error(
                  message: (l is CacheFailure)
                      ? CACHE_ERROR_MESSAGE
                      : SERVER_ERROR_MESSAGE)), (r) {
            emit(Loaded(numberTrivia: r));
          });
        });
      } else if (event is GetTriviaForRandomNumber) {
        emit(Loading());
        final result = await getRandomNumberTrivia.call(NoParams());
        result.fold(
            (l) => emit(Error(
                message: (l is CacheFailure)
                    ? CACHE_ERROR_MESSAGE
                    : SERVER_ERROR_MESSAGE)),
            (r) => emit(Loaded(numberTrivia: r)));
      }
    });
  }
}
