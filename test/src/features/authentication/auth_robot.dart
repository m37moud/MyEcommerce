import 'package:ecommerce_app/src/common_widgets/alert_dialogs.dart';
import 'package:ecommerce_app/src/common_widgets/primary_button.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:ecommerce_app/src/features/products/presentation/home_app_bar/more_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class AuthRobot {
  AuthRobot(this.tester);

  final WidgetTester tester;

  Future<void> openSignInScreen() async {
    final finder = find.byKey(MoreMenuButton.signInKey);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> pumpEmailPasswordSign(
      {required FakeAuthRepository authRepo,
      required EmailPasswordSignInFormType formType,
      VoidCallback? onTap}) async {
    await tester.pumpWidget(ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(authRepo)],
        child: MaterialApp(
          home: Scaffold(
            body: EmailPasswordSignInContents(
              formType: formType,
              onSignedIn: onTap,
            ),
          ),
        )));
  }

  Future<void> tapEmailPasswordSubmitButton() async {
    final confirmDialogBtnFinder = find.byType(PrimaryButton);
    expect(confirmDialogBtnFinder, findsOneWidget);
    await tester.tap(confirmDialogBtnFinder);
    await tester.pumpAndSettle();
  }

  Future<void> fillEmailToTest(String email) async {
    final emailTextField = find.byKey(EmailPasswordSignInScreen.emailKey);
    expect(emailTextField, findsOneWidget);
    await tester.enterText(emailTextField, email);
  }

  Future<void> fillPasswordToTest(String pass) async {
    final passTextField = find.byKey(EmailPasswordSignInScreen.passwordKey);
    expect(passTextField, findsOneWidget);
    await tester.enterText(passTextField, pass);
  }

  Future<void> signInWithEmailAndPassAndThenTapConfirm() async {
    await fillEmailToTest('test@test.com');
    await fillPasswordToTest('test@test.com');
    await tapEmailPasswordSubmitButton();
  }

  Future<void> openAccountScreen() async {
    final finder = find.byKey(MoreMenuButton.accountKey);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> pumpAccountScreenWidget({FakeAuthRepository? authRepo}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          if (authRepo != null)
            authRepositoryProvider.overrideWithValue(
              authRepo,
            )
        ],
        child: const MaterialApp(
          home: AccountScreen(),
        ),
      ),
    );
  }

  Future<void> clickLogoutButton() async {
    final accountBtnFinder = find.text('Logout');
    expect(accountBtnFinder, findsOneWidget);
    await tester.tap(accountBtnFinder);
    await tester.pump();

    // final logoutButton = find.text('Logout');
    // expect(logoutButton, findsOneWidget);
    // await tester.tap(logoutButton);
    // await tester.pump();
  }

  void getConfirmDialog() {
    final dialogFinder = find.text('Are you sure?');
    expect(dialogFinder, findsOneWidget);
  }

  Future<void> dialogCancelButtonClicked() async {
    final cancelWidget = find.text('Cancel');
    await tester.tap(cancelWidget);
    await tester.pump();
  }

  void expectConfirmDialogNotFound() {
    final dialogFinder = find.text('Are you sure?');

    expect(dialogFinder, findsNothing);
  }

  Future<void> clickDialogAccountButton() async {
    final confirmDialogBtnFinder = find.byKey(kDialogDefaultKey);
    expect(confirmDialogBtnFinder, findsOneWidget);
    await tester.tap(confirmDialogBtnFinder);
    await tester.pump();
  }

  Future<void> tapDialogLogoutButton() async {
    final logoutButton = find.byKey(kDialogDefaultKey);
    expect(logoutButton, findsOneWidget);
    await tester.tap(logoutButton);
    await tester.pump();
  }

  void expectExceptionDialogFound() {
    final dialogFinder = find.text('Error');

    expect(dialogFinder, findsOneWidget);
  }

  void expectExceptionDialogNotFound() {
    final dialogFinder = find.text('Error');

    expect(dialogFinder, findsNothing);
  }

  void expectCircularProgressBar() {
    final finder = find.byType(CircularProgressIndicator);
    expect(finder, findsOneWidget);
  }
}
