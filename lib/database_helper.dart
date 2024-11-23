import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  static Database? _database;

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  DatabaseHelper._privateConstructor();

  // check if database already exists
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'food_ordering.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // create orders table in database
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orders(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        date TEXT, 
        food_item TEXT, 
        cost REAL
      )
    ''');
  }

  // insert order into database
  Future<void> insertOrder(String date, String foodItem, double cost) async {
    final db = await database;
    await db.insert(
      'orders',
      {'date': date, 'food_item': foodItem, 'cost': cost},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Debugging: Print the inserted data
    print("Inserted order: Date: $date, Food: $foodItem, Cost: $cost");
  }

  // get orders for a specific date
  Future<List<Map<String, dynamic>>> getOrdersForDate(String date) async {
    final db = await database;
    return await db.query(
      'orders',
      where: 'date = ?',
      whereArgs: [date],
    );
  }
}
