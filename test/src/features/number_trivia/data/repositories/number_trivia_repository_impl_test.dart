import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/src/core/platform/network_info.dart';
import 'package:number_trivia/src/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/src/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/src/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks(
    [NumberTriviaRemoteDataSource, NumberTriviaLocalDataSource, NetworkInfo])
void main() {
  MockNumberTriviaRemoteDataSource mockRemoteDataSource =
      MockNumberTriviaRemoteDataSource();
  MockNumberTriviaLocalDataSource mockLocalDataSource =
      MockNumberTriviaLocalDataSource();
  MockNetworkInfo mockNetworkInfo = MockNetworkInfo();
  NumberTriviaRepositoryImpl repositoryImpl = NumberTriviaRepositoryImpl(
    remoteDataSource: mockRemoteDataSource,
    localDataSource: mockLocalDataSource,
    networkInfo: mockNetworkInfo,
  );
}
