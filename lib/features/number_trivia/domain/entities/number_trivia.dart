import 'package:equatable/equatable.dart';

class NumberTrivia extends Equatable {
  final String text;
  final double number;

  const NumberTrivia({
    required this.text,
    required this.number,
  }) : super();

  @override
  List<Object?> get props => [text, number];
}
