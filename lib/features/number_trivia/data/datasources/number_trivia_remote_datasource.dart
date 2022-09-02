import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:clean_code/core/error/exceptions.dart';
import 'package:clean_code/features/number_trivia/data/models/number_trivia_model.dart';

import '../../domain/entities/number_trivia.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int? number);

  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;
  NumberTriviaRemoteDataSourceImpl({required this.client});
  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int? number) async {
    try {
      final response = await client.get(
          Uri.parse('http://numbersapi.com/$number'),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return NumberTriviaModel.fromJson(json);
      }
      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    try {
      final response = await client.get(
          Uri.parse('http://numbersapi.com/random'),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return NumberTriviaModel.fromJson(json);
      }
      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }
}
