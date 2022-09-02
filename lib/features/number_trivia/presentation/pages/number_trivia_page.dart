import 'package:clean_code/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_code/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  NumberTriviaPage({Key? key}) : super(key: key);

  final _bloc = sl<NumberTriviaBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
        builder: (context, state) {
          return SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: const Placeholder());
        },
        bloc: _bloc,
      ),
    );
  }
}
