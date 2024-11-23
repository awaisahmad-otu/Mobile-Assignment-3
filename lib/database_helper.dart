import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  static Database? _database;

  // Singleton pattern for Database
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'food_ordering.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Create tables
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

  // Insert order into database
  Future<void> insertOrder(String date, String foodItem, double cost) async {
    final db = await database;
    await db.insert(
      'orders',
      {'date': date, 'food_item': foodItem, 'cost': cost},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get orders for a specific date
  Future<List<Map<String, dynamic>>> getOrdersForDate(String date) async {
    final db = await database;
    return await db.query(
      'orders',
      where: 'date = ?',
      whereArgs: [date],
    );
  }

  // Update an order
  Future<void> updateOrder(int id, String date, String foodItem, double cost) async {
    final db = await database;
    await db.update(
      'orders',
      {'date': date, 'food_item': foodItem, 'cost': cost},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete an order
  Future<void> deleteOrder(int id) async {
    final db = await database;
    await db.delete(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
