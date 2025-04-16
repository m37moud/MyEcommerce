import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mock.dart';
import '../../auth_robot.dart';

void main() {
  const testEmail = 'test@test.com';
  const testPass = '1234';
  late MockAuthRepository authRepo;
  setUp(() {
    authRepo = MockAuthRepository();
  });
  group('sign in', () {
    testWidgets('''
    Given formType is SignIn
    When tap in sig-in button 
    then signInWitheEmailAndPassword not called
    and onTap called
    and error alert no shown
    ''', (tester) async {
      final r = AuthRobot(tester);
      await r.pumpEmailPasswordSign(
          authRepo: authRepo, formType: EmailPasswordSignInFormType.signIn);
      await r.tapEmailPasswordSubmitButton();

      verifyNever(() => authRepo.signInWithEmailAndPassword(any(), any()));
    });

    testWidgets('''
    Given formType is SignIn
    When enter valid email and pass
    and tap in sig-in button 
    then signInWitheEmailAndPassword called
    ''', (tester) async {
      var isPressed = false;
      final r = AuthRobot(tester);
      when(() => authRepo.signInWithEmailAndPassword(testEmail, testPass))
          .thenAnswer((_) => Future.value());
      await r.pumpEmailPasswordSign(
          authRepo: authRepo,
          formType: EmailPasswordSignInFormType.signIn,
          onTap: () => isPressed = true);
      await r.fillEmailToTest(testEmail);
      await r.fillPasswordToTest(testPass);
      await r.tapEmailPasswordSubmitButton();

      verify(() => authRepo.signInWithEmailAndPassword(testEmail, testPass))
          .called(1);
      r.expectExceptionDialogNotFound();
      expect(isPressed, true);
    });
  });
}
