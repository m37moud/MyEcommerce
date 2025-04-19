import 'package:ecommerce_app/src/features/checkout/application/fake_checkout_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentButtonControllerNotifier extends StateNotifier<AsyncValue<void>> {
  PaymentButtonControllerNotifier({required this.checkoutService})
      : super(AsyncData(null));
  final FakeCheckoutService checkoutService;

  Future<void> pay() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(checkoutService.placeOrder);
  }
}

final paymentControllerProvider =
    StateNotifierProvider.autoDispose<PaymentButtonControllerNotifier, AsyncValue<void>>(
        (ref) {
          return PaymentButtonControllerNotifier(checkoutService: ref.watch(checkoutServiceProvider));
        });
