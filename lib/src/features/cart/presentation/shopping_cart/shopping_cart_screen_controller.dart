import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/products/presentation/home_app_bar/shopping_cart_icon.dart';
import 'package:riverpod/riverpod.dart';

class ShoppingCartScreenController extends StateNotifier<AsyncValue<void>> {
  ShoppingCartScreenController({required this.cartService})
      : super(AsyncData(null));
  final CartService cartService;

  Future<void> updateItemQuantity(ProductID productId, int quantity) async {
    state = AsyncLoading();
    final item = Item(productId: productId, quantity: quantity);
    state = await AsyncValue.guard(() => cartService.setItem(item));
  }

  Future<void> removeItemById(ProductID productId) async {
    state = AsyncLoading();
    state = await AsyncValue.guard(() => cartService.removeItemById(productId));
  }
}

final shoppingControllerProvider =
    StateNotifierProvider<ShoppingCartScreenController, AsyncValue<void>>(
        (ref) {
  return ShoppingCartScreenController(
      cartService: ref.watch(cartServiceProvider));
});
