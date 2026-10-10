import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/category_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'easymart.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        phone TEXT,
        password_hash TEXT,
        role TEXT,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        category_id INTEGER,
        price REAL,
        unit TEXT,
        stock INTEGER,
        image_path TEXT,
        is_featured INTEGER DEFAULT 0,
        is_available INTEGER DEFAULT 1,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE cart_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        product_id INTEGER,
        quantity INTEGER,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE addresses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        label TEXT,
        address TEXT,
        city TEXT,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_number TEXT,
        user_id INTEGER,
        subtotal REAL,
        delivery_fee REAL,
        discount REAL,
        total REAL,
        payment_method TEXT,
        status TEXT,
        delivery_address TEXT,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER,
        product_id INTEGER,
        product_name TEXT,
        quantity INTEGER,
        unit_price REAL,
        unit TEXT,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        product_id INTEGER,
        created_at TEXT
      )
    ''');
  }

  Future<void> seedDemoData() async {
    final db = await database;

    final existingUsers = await db.query('users');
    if (existingUsers.isEmpty) {
      await db.insert('users', {
        'name': 'Demo User',
        'email': 'user@easymart.com',
        'phone': '09171234567',
        'password_hash': 'f3cdb2e4f2ee8b94b5fe6d602c4f8d1d7d61b1d0d5e4394dfe89634f6dbb5b65',
        'role': 'User',
        'created_at': DateTime.now().toIso8601String(),
      });

      await db.insert('users', {
        'name': 'Admin User',
        'email': 'admin@easymart.com',
        'phone': '09179876543',
        'password_hash': '89b1c7568f47a1d3a5d69f5c6b93a45d66dabb1d3d3e2f0dbc7e9d3c0e7d90a',
        'role': 'Admin',
        'created_at': DateTime.now().toIso8601String(),
      });
    }

    final categoryCount = await db.query('categories');
    if (categoryCount.isEmpty) {
      final categories = [
        'Fruits', 'Vegetables', 'Meat and Seafood', 'Dairy and Eggs',
        'Rice and Grains', 'Bread and Bakery', 'Snacks and Biscuits',
        'Beverages', 'Canned Goods', 'Frozen Foods', 'Personal Care',
        'Household Cleaning', 'Cooking Essentials', 'Baby Products'
      ];

      for (final category in categories) {
        await db.insert('categories', {
          'name': category,
          'created_at': DateTime.now().toIso8601String(),
        });
      }
    }

    final productCount = await db.query('products');
    if (productCount.isEmpty) {
      final rows = await db.query('categories');
      final categoryMap = {
        'Fruits': rows.firstWhere((e) => e['name'] == 'Fruits')['id'],
        'Vegetables': rows.firstWhere((e) => e['name'] == 'Vegetables')['id'],
        'Meat and Seafood': rows.firstWhere((e) => e['name'] == 'Meat and Seafood')['id'],
        'Dairy and Eggs': rows.firstWhere((e) => e['name'] == 'Dairy and Eggs')['id'],
        'Rice and Grains': rows.firstWhere((e) => e['name'] == 'Rice and Grains')['id'],
        'Bread and Bakery': rows.firstWhere((e) => e['name'] == 'Bread and Bakery')['id'],
        'Snacks and Biscuits': rows.firstWhere((e) => e['name'] == 'Snacks and Biscuits')['id'],
        'Beverages': rows.firstWhere((e) => e['name'] == 'Beverages')['id'],
        'Canned Goods': rows.firstWhere((e) => e['name'] == 'Canned Goods')['id'],
        'Frozen Foods': rows.firstWhere((e) => e['name'] == 'Frozen Foods')['id'],
        'Personal Care': rows.firstWhere((e) => e['name'] == 'Personal Care')['id'],
        'Household Cleaning': rows.firstWhere((e) => e['name'] == 'Household Cleaning')['id'],
        'Cooking Essentials': rows.firstWhere((e) => e['name'] == 'Cooking Essentials')['id'],
        'Baby Products': rows.firstWhere((e) => e['name'] == 'Baby Products')['id'],
      };

      final sampleProducts = [
        {'name': 'Rice', 'description': 'Premium rice for everyday meals.', 'category_id': categoryMap['Rice and Grains']!, 'price': 55.0, 'unit': 'kg', 'stock': 40, 'image_path': 'assets/images/rice.png', 'is_featured': 1},
        {'name': 'Eggs', 'description': 'Farm-fresh eggs.', 'category_id': categoryMap['Dairy and Eggs']!, 'price': 12.0, 'unit': 'piece', 'stock': 70, 'image_path': 'assets/images/eggs.png', 'is_featured': 1},
        {'name': 'Fresh Milk', 'description': 'Vitamin-rich fresh milk.', 'category_id': categoryMap['Dairy and Eggs']!, 'price': 95.0, 'unit': 'liter', 'stock': 36, 'image_path': 'assets/images/milk.png', 'is_featured': 1},
        {'name': 'Bananas', 'description': 'Sweet and fresh bananas.', 'category_id': categoryMap['Fruits']!, 'price': 80.0, 'unit': 'kg', 'stock': 24, 'image_path': 'assets/images/banana.png', 'is_featured': 1},
        {'name': 'Tomatoes', 'description': 'Fresh tomatoes for cooking.', 'category_id': categoryMap['Vegetables']!, 'price': 70.0, 'unit': 'kg', 'stock': 32, 'image_path': 'assets/images/tomato.png', 'is_featured': 1},
        {'name': 'Potatoes', 'description': 'Crispy and versatile potatoes.', 'category_id': categoryMap['Vegetables']!, 'price': 90.0, 'unit': 'kg', 'stock': 45, 'image_path': 'assets/images/potato.png', 'is_featured': 1},
        {'name': 'Chicken', 'description': 'Fresh chicken pieces.', 'category_id': categoryMap['Meat and Seafood']!, 'price': 220.0, 'unit': 'kg', 'stock': 20, 'image_path': 'assets/images/chicken.png', 'is_featured': 1},
        {'name': 'Bread', 'description': 'Soft loaf bread.', 'category_id': categoryMap['Bread and Bakery']!, 'price': 45.0, 'unit': 'pack', 'stock': 18, 'image_path': 'assets/images/bread.png', 'is_featured': 1},
        {'name': 'Bottled Water', 'description': 'Refreshing drinking water.', 'category_id': categoryMap['Beverages']!, 'price': 20.0, 'unit': 'bottle', 'stock': 52, 'image_path': 'assets/images/water.png', 'is_featured': 1},
        {'name': 'Cooking Oil', 'description': 'Healthy cooking oil.', 'category_id': categoryMap['Cooking Essentials']!, 'price': 85.0, 'unit': 'liter', 'stock': 25, 'image_path': 'assets/images/oil.png', 'is_featured': 1},
        {'name': 'Instant Noodles', 'description': 'Fast and tasty noodles.', 'category_id': categoryMap['Snacks and Biscuits']!, 'price': 18.0, 'unit': 'pack', 'stock': 80, 'image_path': 'assets/images/noodles.png', 'is_featured': 1},
        {'name': 'Laundry Detergent', 'description': 'Powerful everyday detergent.', 'category_id': categoryMap['Household Cleaning']!, 'price': 25.0, 'unit': 'pack', 'stock': 28, 'image_path': 'assets/images/detergent.png', 'is_featured': 1},
      ];

      for (final product in sampleProducts) {
        await db.insert('products', {
          ...product,
          'description': product['description'],
          'is_available': 1,
          'created_at': DateTime.now().toIso8601String(),
        });
      }
    }
  }

  Future<UserModel?> loginUser(String email, String password) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.trim()],
    );

    if (maps.isEmpty) return null;

    final user = UserModel.fromMap(maps.first);
    if (user.passwordHash != _hashPassword(password)) return null;
    return user;
  }

  Future<int> registerUser(UserModel user) async {
    final db = await database;
    return db.insert('users', user.toMap());
  }

  Future<List<CategoryModel>> getCategories() async {
    final db = await database;
    final rows = await db.query('categories', orderBy: 'id ASC');
    return rows.map((e) => CategoryModel.fromMap(e)).toList();
  }

  Future<List<ProductModel>> getProducts({String? categoryName, String? query}) async {
    final db = await database;
    String sql = 'SELECT * FROM products';
    final args = <dynamic>[];

    if (categoryName != null && categoryName.isNotEmpty) {
      final categoryId = await _getCategoryId(categoryName);
      if (categoryId != null) {
        sql += ' WHERE category_id = ?';
        args.add(categoryId);
      }
    }

    if (query != null && query.trim().isNotEmpty) {
      sql += args.isEmpty ? ' WHERE ' : ' AND ';
      sql += ' LOWER(name) LIKE ?';
      args.add('%${query.toLowerCase()}%');
    }

    sql += ' ORDER BY is_featured DESC, id DESC';

    final rows = await db.rawQuery(sql, args);
    return rows.map((e) => ProductModel.fromMap(e)).toList();
  }

  Future<int?> _getCategoryId(String name) async {
    final db = await database;
    final rows = await db.query('categories', where: 'name = ?', whereArgs: [name]);
    if (rows.isEmpty) return null;
    return rows.first['id'] as int;
  }

  Future<int> insertCategory(String name) async {
    final db = await database;
    return db.insert('categories', {
      'name': name,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<int> updateCategory(int id, String name) async {
    final db = await database;
    return db.update('categories', {'name': name}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    return db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertProduct(ProductModel product) async {
    final db = await database;
    return db.insert('products', product.toMap());
  }

  Future<int> updateProduct(ProductModel product) async {
    final db = await database;
    return db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getCartItems(int userId) async {
    final db = await database;
    return db.rawQuery('''
      SELECT ci.id, ci.product_id, p.name, p.image_path, p.unit, p.price, ci.quantity
      FROM cart_items ci
      INNER JOIN products p ON p.id = ci.product_id
      WHERE ci.user_id = ?
      ORDER BY ci.id DESC
    ''', [userId]);
  }

  Future<void> addToCart(int userId, int productId, int quantity) async {
    final db = await database;
    final existing = await db.query(
      'cart_items',
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
    );

    if (existing.isNotEmpty) {
      final current = (existing.first['quantity'] as int?) ?? 0;
      await db.update(
        'cart_items',
        {'quantity': current + quantity},
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
    } else {
      await db.insert('cart_items', {
        'user_id': userId,
        'product_id': productId,
        'quantity': quantity,
        'created_at': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> updateCartItemQuantity(int cartId, int quantity) async {
    final db = await database;
    await db.update('cart_items', {'quantity': quantity}, where: 'id = ?', whereArgs: [cartId]);
  }

  Future<void> removeFromCart(int cartId) async {
    final db = await database;
    await db.delete('cart_items', where: 'id = ?', whereArgs: [cartId]);
  }

  Future<void> clearCart(int userId) async {
    final db = await database;
    await db.delete('cart_items', where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<void> placeOrder({
    required int userId,
    required String orderNumber,
    required String address,
    required String paymentMethod,
    required double subtotal,
    required double deliveryFee,
    required double discount,
    required double total,
  }) async {
    final db = await database;

    await db.transaction((txn) async {
      final orderId = await txn.insert('orders', {
        'order_number': orderNumber,
        'user_id': userId,
        'subtotal': subtotal,
        'delivery_fee': deliveryFee,
        'discount': discount,
        'total': total,
        'payment_method': paymentMethod,
        'status': 'Order Placed',
        'delivery_address': address,
        'created_at': DateTime.now().toIso8601String(),
      });

      final cartItems = await txn.query(
        'cart_items',
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      for (final item in cartItems) {
        final product = await txn.query(
          'products',
          where: 'id = ?',
          whereArgs: [item['product_id']],
        );

        if (product.isEmpty) continue;

        final productData = product.first;
        final quantity = item['quantity'] as int;
        final currentStock = (productData['stock'] as int?) ?? 0;

        await txn.insert('order_items', {
          'order_id': orderId,
          'product_id': item['product_id'],
          'product_name': productData['name'],
          'quantity': quantity,
          'unit_price': productData['price'],
          'unit': productData['unit'],
          'created_at': DateTime.now().toIso8601String(),
        });

        await txn.update(
          'products',
          {'stock': currentStock - quantity},
          where: 'id = ?',
          whereArgs: [item['product_id']],
        );
      }

      await txn.delete('cart_items', where: 'user_id = ?', whereArgs: [userId]);
    });
  }

  Future<List<OrderModel>> getOrdersForUser(int userId) async {
    final db = await database;
    final rows = await db.query(
      'orders',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );
    return rows.map((e) => OrderModel.fromMap(e)).toList();
  }

  Future<List<OrderModel>> getAllOrders() async {
    final db = await database;
    final rows = await db.query('orders', orderBy: 'id DESC');
    return rows.map((e) => OrderModel.fromMap(e)).toList();
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    final db = await database;
    await db.update('orders', {'status': status}, where: 'id = ?', whereArgs: [orderId]);
  }

  Future<List<Map<String, dynamic>>> getOrderItems(int orderId) async {
    final db = await database;
    return db.query(
      'order_items',
      where: 'order_id = ?',
      whereArgs: [orderId],
    );
  }

  Future<String> getUserEmail(int userId) async {
    final db = await database;
    final rows = await db.query('users', where: 'id = ?', whereArgs: [userId]);
    return (rows.first['email'] as String?) ?? '';
  }

  Future<int> getUserCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM users');
    return (result.first['count'] as int?) ?? 0;
  }

  Future<int> getProductCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM products');
    return (result.first['count'] as int?) ?? 0;
  }

  Future<int> getCategoryCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM categories');
    return (result.first['count'] as int?) ?? 0;
  }

  Future<int> getPendingOrdersCount() async {
    final db = await database;
    final result = await db.rawQuery("SELECT COUNT(*) as count FROM orders WHERE status != 'Delivered' AND status != 'Cancelled'");
    return (result.first['count'] as int?) ?? 0;
  }

  Future<int> getDeliveredOrdersCount() async {
    final db = await database;
    final result = await db.rawQuery("SELECT COUNT(*) as count FROM orders WHERE status = 'Delivered'");
    return (result.first['count'] as int?) ?? 0;
  }

  Future<int> getLowStockProductsCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM products WHERE stock <= 10');
    return (result.first['count'] as int?) ?? 0;
  }

  Future<Map<String, dynamic>> getDashboardSummary() async {
    final db = await database;
    final products = await db.rawQuery('SELECT COUNT(*) as total FROM products');
    final categories = await db.rawQuery('SELECT COUNT(*) as total FROM categories');
    final customers = await db.rawQuery("SELECT COUNT(*) as total FROM users WHERE role = 'User'");
    final orders = await db.rawQuery('SELECT COUNT(*) as total FROM orders');
    final pending = await db.rawQuery("SELECT COUNT(*) as total FROM orders WHERE status != 'Delivered' AND status != 'Cancelled'");
    final delivered = await db.rawQuery("SELECT COUNT(*) as total FROM orders WHERE status = 'Delivered'");
    final lowStock = await db.rawQuery('SELECT COUNT(*) as total FROM products WHERE stock <= 10');

    return {
      'products': (products.first['total'] as int?) ?? 0,
      'categories': (categories.first['total'] as int?) ?? 0,
      'customers': (customers.first['total'] as int?) ?? 0,
      'orders': (orders.first['total'] as int?) ?? 0,
      'pending': (pending.first['total'] as int?) ?? 0,
      'delivered': (delivered.first['total'] as int?) ?? 0,
      'lowStock': (lowStock.first['total'] as int?) ?? 0,
    };
  }

  Future<String> _hashPassword(String password) async {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static late final SharedPreferences _prefs;

  static Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setLoggedInUserId(int userId) async {
    await _prefs.setInt('logged_in_user_id', userId);
  }

  static Future<int?> getLoggedInUserId() async {
    return _prefs.getInt('logged_in_user_id');
  }

  static Future<void> clearSession() async {
    await _prefs.remove('logged_in_user_id');
  }
}

String hashString(String input) {
  return sha256.convert(utf8.encode(input)).toString();
}
