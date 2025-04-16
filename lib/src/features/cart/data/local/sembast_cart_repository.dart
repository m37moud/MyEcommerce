import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

import 'local_cart_repository.dart';

class SembastCartRepository implements LocalCartRepository {
  SembastCartRepository(this.db);

  final Database db;
  final store = StoreRef.main();

  static Future<Database> createDatabase(String fileName) async {
    if (kIsWeb) {
      final appDocDir = await getApplicationDocumentsDirectory();
      return databaseFactoryIo.openDatabase("${appDocDir.path}/$fileName");
    } else {
      return databaseFactoryWeb.openDatabase(fileName);
    }
  }

  static Future<SembastCartRepository> makeItDefault() async {
    return SembastCartRepository(await createDatabase("default.db"));
  }

  static const String kDatabaseKey = 'database-key-file';

  @override
  Future<Cart> fetchCart() async {
    final cartJson = store.record(kDatabaseKey).get(db) as String?;
    if (cartJson != null) {
      return Cart.fromJson(cartJson);
    } else {
      return Cart();
    }
  }

  @override
  Future<void> setCart(Cart cart) {
    final record = store.record(kDatabaseKey);
    return record.put(db, cart.toJson());
  }

  @override
  Stream<Cart> watchCart() {
    final record = store.record(kDatabaseKey);
    return record.onSnapshot(db).map((snapShot) {
      if (snapShot != null) {
        return Cart.fromJson(snapShot.value as String);
      } else {
        return const Cart();
      }
    });
  }
}
