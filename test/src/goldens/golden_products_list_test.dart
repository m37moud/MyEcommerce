import 'dart:ui';

import 'package:ecommerce_app/src/app.dart';
import 'package:flutter_test/flutter_test.dart';

import '../robot.dart';

main() {
  final sizeVariant = ValueVariant<Size>({
    const Size(300, 600),
    const Size(600, 800),
    const Size(1000, 1000),
  });
  testWidgets('golden products list test', (tester) async {
    final r = Robot(tester);
    final currentSize = sizeVariant.currentValue!;
    await r.golden.setSurfaceSize(currentSize);
    await r.golden.loadRobotoFont();
    await r.golden.loadMaterialIconFont();
    await r.pumpMyApp();
    await r.golden.precacheImages();
    final finder = find.byType(MyApp);
    await expectLater(
        finder,
        matchesGoldenFile(
            'products_list${currentSize.width.toInt()}x${currentSize.height.toInt()}.png'));
  }, variant: sizeVariant, tags: ['golden'], skip: true);
}
