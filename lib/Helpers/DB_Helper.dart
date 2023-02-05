import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../modals/coupon.dart';

class DBHelper {
  DBHelper._();
  static final DBHelper dbHelper = DBHelper._();

  final String dbName = "coupon.db";
  final String tableName = "coupons";
  final String colId = "id";
  final String colCoupon = "coupon";
  final String colIsUsed = "isUsed";

  Database? db;

  Future<void> initDB() async {
    String directory = await getDatabasesPath();
    String path = join(directory, dbName);

    db = await openDatabase(path, version: 1, onCreate: (db, version) {});

    await db?.execute(
        "CREATE TABLE IF NOT EXISTS $tableName ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colCoupon TEXT,$colIsUsed TEXT)");
  }

  insertRecord() async {
    await initDB();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isInserted = prefs.getBool(tableName) ?? false;

    if (isInserted == false) {
      for (int i = 1; i <= 10; i++) {
        String query =
            "INSERT INTO $tableName($colCoupon, $colIsUsed) VALUES(?, ?)";
        List args = ["coupon$i", "false"];

        await db?.rawInsert(query, args);
      }
      prefs.setBool(tableName, true);
    }
  }

  Future fetchAllRecords() async {
    await initDB();

    String query = "SELECT * FROM $tableName";

    List<Map<String, dynamic>> allCoupon = await db!.rawQuery(query);

    List<Coupon> couponList =
    allCoupon.map((e) => Coupon.fromJSON(data: e)).toList();

    return couponList;
  }

  updateRecord({required int id}) async {
    await initDB();

    int? a = await db?.rawUpdate(
        "Update $tableName SET $colIsUsed= ? WHERE $colId = ?", ["true", id]);

    print(a);
  }
}
