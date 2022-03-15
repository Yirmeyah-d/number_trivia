import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/src/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/src/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/src/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'get_concrete_number_trivia_test.mocks.dart';

// new annotation
@GenerateMocks([NumberTriviaRepository])
void main() {
  // initialization outside of setUp
  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(number: 1, text: 'test');
  final mockNumberTriviaRepository = MockNumberTriviaRepository();
  final useCase = GetConcreteNumberTrivia(mockNumberTriviaRepository);

  test(
    'should get trivia for the number from the repository',
    () async {
      //arrange
      when(mockNumberTriviaRepository.getConcreteNumberTrivia(1))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      final result = await useCase(Params(number: tNumber));
      // assert
      expect(result, Right(tNumberTrivia));
      verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
