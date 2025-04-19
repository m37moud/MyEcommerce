import 'package:flutter_test/flutter_test.dart';

import '../../robot.dart';

main() {
  testWidgets('auth flow test', (tester) async {
    final r = Robot(tester);
    await r.pumpMyApp();
    r.expectFindAllProduct();
    await r.openPopUpMenu();
    await r.authRobot.openSignInScreen();
    await r.authRobot.signInWithEmailAndPassAndThenTapConfirm();
    r.expectFindAllProduct();
    await r.openPopUpMenu();
    await r.authRobot.openAccountScreen();
    await r.authRobot.clickLogoutButton();
    r.authRobot.getConfirmDialog();
    await r.authRobot.tapDialogLogoutButton();
    r.expectFindAllProduct();

  });
}
