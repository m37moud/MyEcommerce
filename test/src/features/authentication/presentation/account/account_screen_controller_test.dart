import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mock.dart';


void main() {
  late MockAuthRepository authRepo;
  late AccountScreenControllerNotifier controller;
  setUp(() {
    authRepo = MockAuthRepository();
    controller = AccountScreenControllerNotifier(authRepo: authRepo);
  });
  group('AccountScreenController', () {
    test('init state is null', () {
      verifyNever(authRepo.signOut);
      expect(controller.state, AsyncData<void>(null));
    });
    test('sign out success', () async {
      //setup
      // when(() => authRepo.signOut()).thenAnswer((_) => Future.value(null));
      //stub
      when(authRepo.signOut).thenAnswer((_) => Future.value(null));
      // expect later
      expectLater(controller.stream,
          emitsInOrder([AsyncLoading<void>(), AsyncData<void>(null)]));
      //run
      await controller.signOut();
      //verify
      verify(authRepo.signOut).called(1);
      // expect(controller.state, AsyncData<void>(null));
    }, timeout: Timeout(Duration(milliseconds: 500)));

    test('sign out failure', () async {
      final exception = Exception('connection failed');
      when(authRepo.signOut).thenThrow(exception);
      // expectLater(controller.stream,
      //     emitsInOrder([AsyncLoading<void>(), isA<AsyncError>()]));
      expectLater(
          controller.stream,
          emitsInOrder([
            AsyncLoading<void>(),
            predicate<AsyncValue<void>>((value) {
              expect(value.hasError, true);
              return true;
            }),
          ]));
      await controller.signOut();
      verify(authRepo.signOut).called(1);
      // expect(controller.state.hasError, true);
      // expect(controller.state, isA<AsyncError>());
    }, timeout: Timeout(Duration(milliseconds: 500)));
  });
}
