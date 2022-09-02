import 'package:clean_code/features/number_trivia/domain/repositories/number_triva_repository.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

MockNumberTriviaRepository get mockNumberTriviaRep =>
    MockNumberTriviaRepository();
