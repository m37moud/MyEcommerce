import 'dart:math';

import 'package:ecommerce_app/src/exceptions/error_logger.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/cart/domain/mutable_cart.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartSyncService {
  CartSyncService(this.ref) {
    _init();
  }

  final Ref ref;

  void _init() {
    ref.listen(authStateChangesProvider, (previous, next) {
      final previousUser = previous?.value;
      final nextUser = next.value;
      if (previousUser == null && nextUser != null) {
        _addLocalCartToRemote(nextUser.uid);
      }
    });
  }

  Future<void> _addLocalCartToRemote(String uid) async {
    try {
      final localRepo = ref.read(localCartRepositoryProvider);
      final localCart = await localRepo.fetchCart();
      if (localCart.items.isNotEmpty) {
        final remoteRpo = ref.read(remoteCartRepositoryProvider);
        final remoteCart = await remoteRpo.fetchCart(uid);
        final localItemToAdd = await _addLocalItem(localCart, remoteCart);
        final updatedRemoteCart = remoteCart.addItems(localItemToAdd);
        await remoteRpo.setCart(uid, updatedRemoteCart);
        await localRepo.setCart(const Cart());
      }
    } catch (e,st) {
     ref.read(errorLoggerProvider).log(e, st);
    }
  }

  Future<List<Item>> _addLocalItem(Cart localCart, Cart remoteCart) async {
    final productRepo = ref.read(productsRepositoryProvider);
    final products = await productRepo.fetchProductList();
    final localItems = <Item>[];
    for (var item in localCart.items.entries) {
      final productId = item.key;
      final localQuantity = item.value;
      final remoteQuantity = remoteCart.items[productId] ?? 0;
      final product = products.firstWhere((p) => p.id == productId);
      final capQuantity =
          min(localQuantity, product.availableQuantity - remoteQuantity);
      if (capQuantity > 0) {
        localItems.add(Item(productId: productId, quantity: capQuantity));
      }
    }
    return localItems;
  }
}

final cartSyncServiceProvider = Provider<CartSyncService>((ref) {
  return CartSyncService(ref);
});
