@Timeout(Duration(milliseconds: 500))
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_controller.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mock.dart';

void main() {
  const testEmail = 'test@test.com';
  const testPass = '1234';
  group('EmailPasswordSignInController', () {
    group('submit', () {
      test('''
Given form type is sign in
when signInWitheEmailAndPassword successes
then return true
and state AsyncData
''', () async {
        final repo = MockAuthRepository();
        final controller = EmailPasswordSignInController(
            authRepository: repo, formType: EmailPasswordSignInFormType.signIn);
        when(() => repo.signInWitheEmailAndPassword(testEmail, testPass))
            .thenAnswer((_) => Future.value());
        expectLater(
            controller.stream,
            emitsInOrder([
              EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.signIn,
                  value: AsyncLoading<void>()),
              EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.signIn,
                  value: AsyncData<void>(null))
            ]));
        final result = await controller.submit(testEmail, testPass);
        expect(result, true);
      }, );

      test('''
Given form type is sign in
when signInWitheEmailAndPassword fail
then return false
and state AsyncError
''', () async {
        final repo = MockAuthRepository();
        final controller = EmailPasswordSignInController(
            formType: EmailPasswordSignInFormType.signIn, authRepository: repo);
        final exception = Exception('connection fail');
        when(() => repo.signInWitheEmailAndPassword(testEmail, testPass))
            .thenThrow(exception);

        expectLater(
            controller.stream,
            emitsInOrder([
              EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.signIn,
                  value: AsyncLoading<void>()),
              predicate<EmailPasswordSignInState>((state) {
                expect(state.formType, EmailPasswordSignInFormType.signIn);
                expect(state.value.hasError, true);
                return true;
              })
            ]));
        final result = await controller.submit(testEmail, testPass);
        expect(result, false);
      });

      test('''
Given form type is register
when createWitheEmailAndPassword successes
then return true
and state AsyncData
''', () async {
        final repo = MockAuthRepository();
        final controller = EmailPasswordSignInController(
            formType: EmailPasswordSignInFormType.register,
            authRepository: repo);
        when(() => repo.createWitheEmailAndPassword(testEmail, testPass))
            .thenAnswer((_) => Future.value());
        expectLater(
            controller.stream,
            emitsInOrder([
              EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.register,
                  value: AsyncLoading<void>()),
              EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.register,
                  value: AsyncData<void>(null))
            ]));
        final result = await controller.submit(testEmail, testPass);
        expect(result, true);
      }, );
      test('''
Given form type is register
when createWitheEmailAndPassword fail
then return false
and state AsyncError
''', () async {
        final repo = MockAuthRepository();
        final controller = EmailPasswordSignInController(
            formType: EmailPasswordSignInFormType.register,
            authRepository: repo);
        final exception = Exception('connection fail');
        when(() => repo.createWitheEmailAndPassword(testEmail, testPass))
            .thenThrow(exception);
        expectLater(
            controller.stream,
            emitsInOrder([
              EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.register,
                  value: AsyncLoading<void>()),
              predicate<EmailPasswordSignInState>((state) {
                expect(state.formType, EmailPasswordSignInFormType.register);
                expect(state.value.hasError, true);

                return true;
              })
            ]));
        await controller.submit(testEmail, testPass);
      }, );
    });

    group('update form type', () {
      test('switch to register state while in signIn', () {
        final authRepo = MockAuthRepository();
        final controller = EmailPasswordSignInController(
            formType: EmailPasswordSignInFormType.signIn,
            authRepository: authRepo);
        controller.updateFormType(EmailPasswordSignInFormType.register);
        expect(
            controller.state,
            EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.register,
                value: AsyncData<void>(null)));
      });
      test('switch to signIn state while in Register', () {
        final authRepo = MockAuthRepository();
        final controller = EmailPasswordSignInController(
            formType: EmailPasswordSignInFormType.register,
            authRepository: authRepo);
        controller.updateFormType(EmailPasswordSignInFormType.signIn);
        expect(
            controller.state,
            EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.signIn,
                value: AsyncData<void>(null)));
      });
    });
  });
}
