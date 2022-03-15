import 'package:fpdart/fpdart.dart';
import 'package:number_trivia/src/core/error/failures.dart';
import 'package:number_trivia/src/core/use_cases/use_case.dart';
import 'package:number_trivia/src/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/src/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  // api.com/random

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    // TODO: implement call
    return await repository.getRandomNumberTrivia();
  }
}
