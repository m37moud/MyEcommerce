import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' show when;

import '../../../../mock.dart';
import '../../auth_robot.dart';

void main() {
  testWidgets('Cancel Logout ...', (tester) async {
    final r = AuthRobot(tester);
    await r.pumpAccountScreenWidget();
    await r.clickLogoutButton();

    r.getConfirmDialog();

    await r.dialogCancelButtonClicked();
    r.expectConfirmDialogNotFound();
  });

  testWidgets('Confirm logout, success', (tester) async {
    final r = AuthRobot(tester);
    await r.pumpAccountScreenWidget();
    await r.clickLogoutButton();
    r.getConfirmDialog();
    await r.tapDialogLogoutButton();
    r.expectConfirmDialogNotFound();
    r.expectExceptionDialogNotFound();
  });

  testWidgets('Confirm logout, failure', (tester) async {
    final r = AuthRobot(tester);
    final authRepository = MockAuthRepository();
    final exception = Exception('Connection Failed');
    when(authRepository.signOut).thenThrow(exception);
    when(authRepository.authStateChanges).thenAnswer(
      (_) => Stream.value(
        AppUser(uid: '123', email: 'test@test.com'),
      ),
    );
    // expect(authRepository.authStateChanges(), emits(testUser));
    await r.pumpAccountScreenWidget(authRepo: authRepository);
    await r.clickLogoutButton();
    r.getConfirmDialog();
    await r.tapDialogLogoutButton();
    r.expectExceptionDialogFound();
  });



  testWidgets('Confirm logout, loading state', (tester) async {
    final r = AuthRobot(tester);
    final authRepository = MockAuthRepository();
    when(authRepository.signOut).thenAnswer(
          (_) => Future.delayed(const Duration(seconds: 1)),
    );
    when(authRepository.authStateChanges).thenAnswer(
          (_) => Stream.value(
        const AppUser(uid: '123', email: 'test@test.com'),
      ),
    );
    await r.pumpAccountScreenWidget(authRepo: authRepository);
    await tester.runAsync(() async {
      await r.clickLogoutButton();
      r.getConfirmDialog();
      await r.tapDialogLogoutButton();
    });
    r.expectCircularProgressBar();
  });
}
