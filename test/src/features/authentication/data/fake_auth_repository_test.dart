import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FakeAuthRepository createAuthRepo() => FakeAuthRepository(addDelay: false);
  const testEmail = 'test@test.com';
  const testPass = '1234';
  final testUser =
      AppUser(uid: testEmail.split('').reversed.join(), email: testEmail);

  group('FakeAuthRepository', () {
    test('currentUser is null', () {
      final repo = createAuthRepo();
      // tearDown(repo.dispose);
      expect(repo.currentUser, null);
      expect(repo.authStateChanges(), emits(null));
    });
    test('currentUser is not null after sign in', () async {
      final repo = createAuthRepo();
      // tearDown(repo.dispose);
      await repo.signInWitheEmailAndPassword(testEmail, testPass);
      expect(repo.currentUser, testUser);
      expect(repo.authStateChanges(), emits(testUser));
    });

    test('currentUser is not null after regeneration', () async {
      final repo = createAuthRepo();
      // tearDown(repo.dispose);
      await repo.createWitheEmailAndPassword(testEmail, testPass);
      expect(repo.currentUser, testUser);
      expect(repo.authStateChanges(), emits(testUser));
    });

    test('currentUser is null after sign out', () async {
      final repo = createAuthRepo();
      // tearDown(repo.dispose);
      await repo.signInWitheEmailAndPassword(testEmail, testPass);
      expect(repo.currentUser, testUser);
      expect(repo.authStateChanges(), emits(testUser));
      await repo.signOut();
      expect(repo.currentUser, null);
      expect(repo.authStateChanges(), emits(null));
    });
  });
}
