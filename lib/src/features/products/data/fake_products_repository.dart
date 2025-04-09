// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/utils/delay.dart';

class FakeProductsRepository {
  final _products = kTestProducts;
  FakeProductsRepository({
     this.addDelay = true,
  });
  final bool addDelay;
  List<Product> getProductList() {
    return _products;
  }

  Product? getProduct(String id) {
   return _getProduct(_products , id);
  }

  Future<List<Product>> fetchProductList() async {
     await delay(addDelay);
    return Future.value(_products);
  }

  Stream<List<Product>> watchProductList() async* {
    await delay(addDelay);
    yield _products;
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductList()
        .map((products) => _getProduct(products , id));
  }

  static Product? _getProduct(List<Product> products, String id) {
     try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}

final productsRepositoryProvider = Provider<FakeProductsRepository>((ref) {
  return FakeProductsRepository();
});

final productListStreamProvider =
    StreamProvider.autoDispose<List<Product>>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.watchProductList();
});
final productListFutureProvider =
    FutureProvider.autoDispose<List<Product>>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.fetchProductList();
});

final productStreamProvider =
    StreamProvider.autoDispose.family<Product?, String>((ref, id) {
  debugPrint('productStreamProvider: $id');
  ref.onDispose(() => debugPrint("productStreamProvider disposed"));
  final link = ref.keepAlive();
  Timer(const Duration(seconds: 5), () {
    link.close();
  });

  final productRepository = ref.watch(productsRepositoryProvider);

  return productRepository.watchProduct(id);
});
