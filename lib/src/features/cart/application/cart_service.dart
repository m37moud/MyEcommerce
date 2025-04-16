// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/cart/domain/mutable_cart.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartService {
  CartService({
    required this.ref
  });
  final Ref ref;
  // final FakeAuthRepository authRepository;
  // final LocalCartRepository localCartRepository;
  // final RemoteCartRepository remoteCartRepository;

  Future<Cart> _fetchCart() {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      return ref.read(remoteCartRepositoryProvider).fetchCart(user.uid);
    } else {
      return ref.read(localCartRepositoryProvider).fetchCart();
    }
  }

  Future<void> _setCart(Cart cart) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      await ref.read(remoteCartRepositoryProvider).setCart(user.uid, cart);
    } else {
      await ref.read(localCartRepositoryProvider).setCart(cart);
    }
  }

  Future<void> setItem(Item item) async {
    final cart = await _fetchCart();
    final updatedCart = cart.setItem(item);
    await _setCart(updatedCart);
  }

  Future<void> addItem(Item item) async {
    final cart = await _fetchCart();
    final updatedCart = cart.addItem(item);
    await _setCart(updatedCart);
  }

  Future<void> removeItemById(ProductID id) async {
    final cart = await _fetchCart();
    final updatedCart = cart.removeItemById(id);
    await _setCart(updatedCart);
  }
}

final cartServiceProvider = Provider<CartService>((ref) {
  return CartService(
    ref: ref
      // authRepository: ref.watch(authRepositoryProvider),
      // localCartRepository: ref.watch(localCartRepositoryProvider),
      // remoteCartRepository: ref.watch(remoteCartRepositoryProvider)
  );
});
