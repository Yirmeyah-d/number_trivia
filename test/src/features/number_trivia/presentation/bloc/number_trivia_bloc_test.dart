import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/src/core/error/failures.dart';
import 'package:number_trivia/src/core/use_cases/use_case.dart';
import 'package:number_trivia/src/core/utils/failure_apis.dart';
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

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'Test');

    void setUpMockInputConverterAndMockGetConcreteSuccess() {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(const Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
    }

    void setUpMockInputConverterAndMockGetConcreteFailure(Failure failure) {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(const Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(failure));
    }

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        // arrange
        setUpMockInputConverterAndMockGetConcreteSuccess();
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

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        setUpMockInputConverterAndMockGetConcreteSuccess();
        // act
        numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));
        // assert
        verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      },
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'emit [NumberTriviaLoading,NumberTriviaLoaded] when data is gotten successfully',
      build: () {
        setUpMockInputConverterAndMockGetConcreteSuccess();
        return numberTriviaBloc;
      },
      act: (bloc) => bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
      expect: () =>
          [NumberTriviaLoading(), NumberTriviaLoaded(trivia: tNumberTrivia)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'emit [NumberTriviaLoading,NumberTriviaError] when getting data fails',
      build: () {
        setUpMockInputConverterAndMockGetConcreteFailure(ServerFailure());
        return numberTriviaBloc;
      },
      act: (bloc) => bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [
        NumberTriviaLoading(),
        const NumberTriviaError(message: SERVER_FAILURE_MESSAGE)
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'emit [NumberTriviaLoading,NumberTriviaError] with a proper message for the error when getting data fails',
      build: () {
        setUpMockInputConverterAndMockGetConcreteFailure(CacheFailure());
        return numberTriviaBloc;
      },
      act: (bloc) => bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [
        NumberTriviaLoading(),
        const NumberTriviaError(message: CACHE_FAILURE_MESSAGE)
      ],
    );
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'Test');

    test(
      'should get data from the random use case',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        numberTriviaBloc.add(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));
        // assert
        verify(mockGetRandomNumberTrivia(NoParams()));
      },
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'emit [NumberTriviaLoading,NumberTriviaLoaded] when data is gotten successfully',
      build: () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        return numberTriviaBloc;
      },
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () =>
          [NumberTriviaLoading(), NumberTriviaLoaded(trivia: tNumberTrivia)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'emit [NumberTriviaLoading,NumberTriviaError] when getting data fails',
      build: () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        return numberTriviaBloc;
      },
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => [
        NumberTriviaLoading(),
        const NumberTriviaError(message: SERVER_FAILURE_MESSAGE)
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'emit [NumberTriviaLoading,NumberTriviaError] with a proper message for the error when getting data fails',
      build: () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        return numberTriviaBloc;
      },
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => [
        NumberTriviaLoading(),
        const NumberTriviaError(message: CACHE_FAILURE_MESSAGE)
      ],
    );
  });
}
