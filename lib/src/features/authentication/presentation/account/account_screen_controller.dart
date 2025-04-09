import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreenControllerNotifier extends StateNotifier<AsyncValue<void>> {
  AccountScreenControllerNotifier({required this.authRepo})
      : super(const AsyncData(null));

  final FakeAuthRepository authRepo;

  Future<bool> signOut() async {
    // try {
    //   state = const AsyncValue<void>.loading();
    //   await authRepo.signOut();
    //   state = const AsyncValue<void>.data(null);
    //   return true;
    // } catch (e, st) {
    //   state = AsyncValue<void>.error(e, st);
    //   return false;
    // }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() => authRepo.signOut());
    return state.hasError == false;
  }
}

final accountScreenControllerProvider = StateNotifierProvider.autoDispose<
    AccountScreenControllerNotifier, AsyncValue<void>>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return AccountScreenControllerNotifier(authRepo: authRepo);
});
