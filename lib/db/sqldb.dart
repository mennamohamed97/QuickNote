import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Sqflite {
  static Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialdb();
      return _db;
    } else {
      return _db;
    }
  }

  Future<Database> initialdb() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, "database.db");
    Database mydb = await openDatabase(path, onCreate: _oncreate, version: 1);
    return mydb;
  }

  Future<void> _oncreate(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute('''
    CREATE TABLE notes (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            note TEXT NOT NULL,
            date TEXT NOT NULL
          )
    ''');
    await batch.commit();
    print("DataBase Tables Created");
  }

  deletedb() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, "database.db");
    await deleteDatabase(path);
  }

  Future<int> insert(String table, Map<String, Object?> values) async {
    Database? mydb = await db;
    values['date'] = DateTime.now().toString().split(' ')[0];
    int response = await mydb!.insert(table, values);
    return response;
  }

  Future<int> update(
      String table, Map<String, Object?> values, String? mywhere) async {
    Database? mydb = await db;
    int response = await mydb!.update(table, values, where: mywhere);
    return response;
  }

  Future<int> delete(String table, String? mywhere) async {
    Database? mydb = await db;
    int response = await mydb!.delete(table, where: mywhere);
    return response;
  }

  Future<List<Map<String, dynamic>>> select(String table) async {
    Database? mydb = await db;
    var response = await mydb!.query(table);
    return response;
  }
}
