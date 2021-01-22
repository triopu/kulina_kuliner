//import 'dart:async';
//
//import 'package:path/path.dart';
//import 'package:sqflite/sqflite.dart';
//import 'package:kulinakuliner/modules/home/models/product.dart';
//
//Class Storage {
//  final Future<Database> database = openDatabase(
//    join(await getDatabasesPath(), 'cart.db'),
//    onCreate: (db, version) {
//      return db.execute(
//          'CREATE TABLE Cart(id INTEGER PRIMARY KEY, name TEXT, image_url TEXT, brand_name TEXT, package_name TEXT, price INTEGER, rating DOUBLE, amount INTEGER, value INTEGER, num REAL)');
//    },
//    version: 1,
//  );
//
//  Future<List<ProductData>> cart() async {
//    final Database db = await database;
//    final List<Map<String, dynamic>> maps = await db.query('cart');
//    return List.generate(maps.length, (i) {
//      return ProductData(
//          id: maps[i]['id'],
//          name: maps[i]['name'],
//          imageUrl: maps[i]['image_url'],
//          brandName: maps[i]['brand_name'],
//          packageName: maps[i]['package_name'],
//          price: maps[i]['price'],
//          rating: maps[i]['rating'],
//          amount: maps[i]['amount']);
//    });
//  }
//
//  Future<void> insertCart(ProductData data) async {
//    final Database db = await database;
//    await db.insert(
//      'cart',
//      ProductData.toMap(data),
//      conflictAlgorithm: ConflictAlgorithm.replace,
//    );
//  }
//
//  Future<void> updateCart(ProductData cart) async {
//    final db = await database;
//    await db.update(
//      'cart',
//      ProductData.toMap(cart),
//      where: "id = ?",
//      whereArgs: [cart.id],
//    );
//  }
//
//  Future<void> deleteCart(int id) async {
//    final db = await database;
//    await db.delete(
//      'cart',
//      where: "id = ?",
//      whereArgs: [id],
//    );
//  }
//}

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:kulinakuliner/modules/home/models/product.dart';

class DbHelper {
  static DbHelper _dbHelper;
  static Database _database;

  DbHelper._createObject();

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper;
  }

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'cart.db';
    var todoDatabase = openDatabase(path, version: 1, onCreate: _createDb);
    return todoDatabase;
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Cart(id INTEGER PRIMARY KEY, name TEXT, image_url TEXT, brand_name TEXT, package_name TEXT, price INTEGER, rating DOUBLE, amount INTEGER, value INTEGER, num REAL)
    ''');
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }

  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.database;
    var mapList = await db.query('cart', orderBy: 'id');
    return mapList;
  }

  Future<int> insert(ProductData object) async {
    Database db = await this.database;
    int count = await db.insert('cart', ProductData.toMap(object));
    return count;
  }

  Future<int> update(ProductData object) async {
    Database db = await this.database;
    int count = await db.update('cart', ProductData.toMap(object),
        where: 'id=?', whereArgs: [object.id]);
    return count;
  }

  Future<int> delete(int id) async {
    Database db = await this.database;
    int count = await db.delete('cart', where: 'id=?', whereArgs: [id]);
    return count;
  }

  Future<List<ProductData>> cart() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cart');
    return List.generate(maps.length, (i) {
      return ProductData(
          id: maps[i]['id'],
          name: maps[i]['name'],
          imageUrl: maps[i]['image_url'],
          brandName: maps[i]['brand_name'],
          packageName: maps[i]['package_name'],
          price: maps[i]['price'],
          rating: maps[i]['rating'],
          amount: maps[i]['amount']);
    });
  }
}
