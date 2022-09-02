import 'package:clean_code/core/presentatiion/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter? inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
      "should return an integer when the string represents an unsigned integer",
      () async {
        //arrange
        const str = '123';
        //act
        final result = inputConverter!.stringToUnsignedInteger(str);
        //assert
        expect(result.isRight(), true);
        expect(result.fold((l) => null, (r) => r), 123);
      },
    );

    test(
      "should return a InvalidInputFailure when the string is not an integer",
      () async {
        //arrange
        const str = 'abc';
        //act
        final result = inputConverter!.stringToUnsignedInteger(str);
        //assert
        expect(result.isRight(), false);
        expect(result.fold((l) => l, (r) => null), InvalidInputFailure());
      },
    );

    test(
      "should return a InvalidInputFailure when the string is a negative integer",
      () async {
        //arrange
        const str = '-123';
        //act
        final result = inputConverter!.stringToUnsignedInteger(str);
        //assert
        expect(result.isRight(), false);
        expect(result.fold((l) => l, (r) => null), InvalidInputFailure());
      },
    );
  });
}
