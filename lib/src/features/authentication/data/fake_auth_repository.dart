// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';

class FakeAuthRepository {
  FakeAuthRepository({
    this.addDelay = true,
  });
  final _authState = InMemoryStore<AppUser?>(null);
  final bool addDelay;

  Stream<AppUser?> authStateChanges() => _authState.stream;
  AppUser? get currentUser => _authState.value;

  Future<void> signInWitheEmailAndPassword(
      String email, String password) async {
    await delay(addDelay);
    if (_authState.value == null) {
      _createUser(email);
    }
  }

  Future<void> createWitheEmailAndPassword(
      String email, String password) async {
    await delay(addDelay);
    if (_authState.value == null) {
      _createUser(email);
    }
  }

  Future<void> signOut() async {
    await delay(addDelay);
    _authState.value = null;
  }

  void dispose() => _authState.close();

  void _createUser(String email) {
    _authState.value =
        AppUser(uid: email.split("").reversed.join(), email: email);
  }
}

final authRepositoryProvider = Provider.autoDispose<FakeAuthRepository>((ref) {
  // final bool isFake = String.fromEnvironment("useFakeRepo") == true;
  // final repo = isFake ? FakeAuthRepository() : FirebaseRepo();
  final repo = FakeAuthRepository();
  ref.onDispose(() => repo.dispose());
  return repo;
});

final authStateChangeProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.authStateChanges();
});
