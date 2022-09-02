import 'package:clean_code/core/network/network_info.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  MockDataConnectionChecker? mockDataConnectionChecker;
  NetworkInfoImpl? networkInfo;
  setUp(() async {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(mockDataConnectionChecker!);
  });

  group('isConnected', () {});

  test(
    "should forward the call to DataConnectioChecker.hasConnection is true",
    () async {
      //arrange
      when(mockDataConnectionChecker?.hasConnection)
          .thenAnswer((_) async => true);
      //act
      final result = await networkInfo?.isConnected;
      //assert
      verify(mockDataConnectionChecker?.hasConnection);
      expect(result, true);
    },
  );

  test(
    "should forward the call to DataConnectioChecker.hasConnection is false",
    () async {
      //arrange
      when(mockDataConnectionChecker?.hasConnection)
          .thenAnswer((_) async => false);
      //act
      final result = await networkInfo?.isConnected;
      //assert
      verify(mockDataConnectionChecker?.hasConnection);
      expect(result, false);
    },
  );
}
