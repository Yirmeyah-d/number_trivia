import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/src/core/utils/input_converter.dart';
import 'package:number_trivia/src/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/src/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:number_trivia/src/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:number_trivia/src/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([
  GetConcreteNumberTrivia,
  GetRandomNumberTrivia,
  InputConverter,
])
void main() {
  late NumberTriviaBloc numberTriviaBloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    numberTriviaBloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be NumberTriviaInitial', () {
    //assert
    expect(numberTriviaBloc.state, equals(NumberTriviaInitial()));
  });

  group('GetTriviaFroConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParse = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'Test');

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(const Right(tNumberParse));
        // act
        numberTriviaBloc.add(const GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'emit [NumberTriviaError] when the input is invalid',
      build: () {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        return numberTriviaBloc;
      },
      act: (bloc) => bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [isA<NumberTriviaError>()],
    );
  });
}
