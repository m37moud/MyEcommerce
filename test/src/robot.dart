import 'package:ecommerce_app/src/app.dart';
import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/presentation/home_app_bar/more_menu_button.dart';
import 'package:ecommerce_app/src/features/products/presentation/products_list/product_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'features/authentication/auth_robot.dart';
import 'features/cart/cart_robot.dart';
import 'features/products/products_robot.dart';
import 'goldens/golden_robot.dart';

class Robot {
  Robot(this.tester)
      : authRobot = AuthRobot(tester),
        products = ProductsRobot(tester),
        cart = CartRobot(tester),
        golden = GoldenRobot(tester);
  final WidgetTester tester;
  final AuthRobot authRobot;
  final ProductsRobot products;
  final CartRobot cart;
  final GoldenRobot golden;

  Future<void> pumpMyApp() async {
    final productRepo = FakeProductsRepository(addDelay: false);
    final authRepo = FakeAuthRepository(addDelay: false);
    await tester.pumpWidget(ProviderScope(overrides: [
      productsRepositoryProvider.overrideWithValue(productRepo),
      authRepositoryProvider.overrideWithValue(authRepo)
    ], child: MyApp()));
    await tester.pumpAndSettle();
  }

  void expectFindAllProduct() {
    final finder = find.byType(ProductCard);
    expect(finder, findsNWidgets(kTestProducts.length));
  }

  Future<void> openPopUpMenu() async {
    final finder = find.byType(MoreMenuButton);
    final matches = finder.evaluate();
    if (matches.isNotEmpty) {
      await tester.tap(finder);
      await tester.pump();
    }
  }
  Future<void> closePage() async {
    final finder = find.byTooltip('Close');
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }
  Future<void> goBack() async {
    final finder = find.byTooltip('Back');
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }
}
