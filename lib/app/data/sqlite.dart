// ignore_for_file: depend_on_referenced_packages
import 'package:buoi8/app/model/cart.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _databaseService = DatabaseHelper._internal();
  factory DatabaseHelper() => _databaseService;
  DatabaseHelper._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, 'db_cart.db');
    print("Đường dẫn database: $databasePath");
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE Cart('
      'productID INTEGER, name TEXT, price FLOAT, img TEXT, des TEXT, count INTEGER)',
    );
  }

  Future<void> insertProduct(Cart productModel) async {
    final db = await _databaseService.database;
    await db.insert(
      'Cart',
      productModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Cart>> products() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('Cart');
    return List.generate(maps.length, (index) => Cart.fromMap(maps[index]));
  }

  Future<Cart> product(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query('product', where: 'id = ?', whereArgs: [id]);
    return Cart.fromMap(maps[0]);
  }

  Future<void> minus(Cart product) async {
    final db = await _databaseService.database;
    if (product.count > 1) product.count--;
    await db.update(
      'Cart',
      product.toMap(),
      where: 'productID = ?',
      whereArgs: [product.productID],
    );
  }

  Future<void> addToCart(Cart product) async {
    final db = await _databaseService.database;
    List<Map<String, dynamic>> existingProduct = await db.query(
      'Cart',
      where: 'productID = ?',
      whereArgs: [product.productID],
    );
    if (existingProduct.isNotEmpty) {
      int newCount = existingProduct[0]['count'] + 1;
      await db.update(
        'Cart',
        {'count': newCount},
        where: 'productID = ?',
        whereArgs: [product.productID],
      );
    } else {
      await db.insert(
        'Cart',
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> deleteProduct(int id) async {
    final db = await _databaseService.database;
    await db.delete(
      'Cart',
      where: 'productID = ?',
      whereArgs: [id],
    );
  }

  Future<void> clear() async {
    final db = await _databaseService.database;
    await db.delete('Cart', where: 'count > 0');
  }

  // lay danh sach san pham trong gio hang
  Future<List<Cart>> getCartItems() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('Cart');
    return List.generate(maps.length, (index) => Cart.fromMap(maps[index]));
  }
}
