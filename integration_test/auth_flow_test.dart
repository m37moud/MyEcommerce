import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/src/robot.dart';

main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Integration auth flow test', (tester) async {
    final r = Robot(tester);
    await r.pumpMyaApp();
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
