// lib/services/database_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/user_model.dart';
import '../models/feedback_model.dart';

class DatabaseService {
  static Database? _database;
  static const String _dbName = 'paruguard.db';
  static const String _tableName = 'users';
  static const String _feedbackTableName = 'feedback';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    // Naikkan versi database ke 2 dan tambahkan onUpgrade
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $_feedbackTableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        kesan TEXT NOT NULL,
        pesan TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // Fungsi ini akan dijalankan jika versi database di perangkat (misal: 1)
  // lebih rendah dari versi di kode (sekarang: 2).
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Jika versi lama < 2, berarti tabel feedback belum ada.
      // Maka kita buat tabelnya.
      await db.execute('''
        CREATE TABLE $_feedbackTableName(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT NOT NULL,
          kesan TEXT NOT NULL,
          pesan TEXT NOT NULL,
          createdAt TEXT NOT NULL
        )
      ''');
    }
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<int> registerUser(User user) async {
    final db = await database;
    final hashedPassword = _hashPassword(user.password);
    return await db.insert(_tableName, {
      'username': user.username,
      'password': hashedPassword,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<User?> loginUser(String username, String password) async {
    final db = await database;
    final hashedPassword = _hashPassword(password);

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'username = ? AND password = ?',
      whereArgs: [username, hashedPassword],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // --- CRUD untuk Feedback ---

  Future<int> addFeedback(FeedbackModel feedback) async {
    final db = await database;
    return await db.insert(_feedbackTableName, feedback.toMap());
  }

  Future<List<FeedbackModel>> getFeedback(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _feedbackTableName,
      where: 'username = ?',
      whereArgs: [username],
      orderBy: 'createdAt DESC', // Tampilkan yang terbaru di atas
    );

    return List.generate(maps.length, (i) => FeedbackModel.fromMap(maps[i]));
  }

  Future<void> deleteFeedback(int id) async {
    final db = await database;
    await db.delete(_feedbackTableName, where: 'id = ?', whereArgs: [id]);
  }
}
