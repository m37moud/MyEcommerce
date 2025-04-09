import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

FakeProductsRepository makeProductRepository() => FakeProductsRepository(addDelay: false);


  group("FakeProductsRepository", () {
    test('getProductList returns global list', () {
      final productRepo = makeProductRepository();
      expect(productRepo.getProductList(), kTestProducts);
    });

    test('getProduct(1) return first item', () {
      final productRepo = makeProductRepository();
      expect(productRepo.getProduct('1'), kTestProducts[0]);
    });

    // test('getProduct(100) throw throwsStateError', () {
    //   final productRepo = makeProductRepository();
    //   expect(() => productRepo.getProduct("100"), throwsStateError);
    // });

    test("getProduct(100) return null", () {
      final productRepository = makeProductRepository();
      expect(productRepository.getProduct("100"), null);
    });
  });
  test('fetchProductList returns global list', () async {
    final productRepository = makeProductRepository();
    expect(await productRepository.fetchProductList(), kTestProducts);
  });
  test('watchProductList returns global list', () {
    final productRepository = makeProductRepository();
    expect(productRepository.watchProductList(), emits(kTestProducts));
  });
  test('watchProduct(1) return first', () {
    final productRepository = makeProductRepository();
    expect(productRepository.watchProduct("1"), emits(kTestProducts[0]));
  });
  test('watchProduct(100) return null', () {
    final productRepository = makeProductRepository();

    expect(productRepository.watchProduct("100"), emits(null));
  });
}
