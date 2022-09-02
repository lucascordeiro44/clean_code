import '../../domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({required String text, required double number})
      : super(number: number, text: text);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(text: json['text'], number: json['number'] * 1.0);
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      "text": text,
      "number": number,
    };
    return json;
  }
}
