import 'package:number_trivia/src/core/error/failures.dart';
import 'package:number_trivia/src/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

extension FailureExtensions on Failure {
  String get mapFailureToMessage {
    switch (this.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
