
import 'package:chatting_app/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([InternetConnectionChecker])

void main(){
  late NetworkInfoImpl networkInfo;
  late MockInternetConnectionChecker mockChecker;

  setUp(() {
    mockChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(mockChecker);
  });

test('should return true when InternetConnectionChecker.hasConnection',
      () async {
    when(mockChecker.hasConnection).thenAnswer((_) async => true);

    final result = await networkInfo.isConnected;

    verify(mockChecker.hasConnection);
    expect(result, true);
  });

  test(
  'should return false when there is no connection',
  () async {
    when(mockChecker.hasConnection).thenAnswer((_) async => false);

    final result = await networkInfo.isConnected;

    verify(mockChecker.hasConnection);
    expect(result, false);
  },
);

}