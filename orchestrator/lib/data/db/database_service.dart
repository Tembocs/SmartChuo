// DatabaseService encapsulates SQLite database initialization and queries.
// Uses the sqlite3 package with sqlite3_flutter_libs to provide native libs.
// Persistently stores the DB under the app documents directory.
import 'dart:io';
import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as s3;

class DatabaseService {
  DatabaseService();

  s3.Database? _db;

  /// Initialize the database, create tables, and seed a demo user if missing.
  Future<void> init() async {
    if (_db != null) return;
    final Directory dir = await getApplicationDocumentsDirectory();
    final dbFile = File('${dir.path}/orchestrator.db');
    _db = s3.sqlite3.open(dbFile.path);
    _createSchema();
    _seed();
  }

  /// Return the open database. Throws if not initialized.
  s3.Database get db {
    final db = _db;
    if (db == null) {
      throw StateError('DatabaseService.init() must be called before use');
    }
    return db;
  }

  /// Create required tables if they do not exist.
  void _createSchema() {
    db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        created_at INTEGER NOT NULL
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        token TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        FOREIGN KEY(user_id) REFERENCES users(id)
      );
    ''');
  }

  /// Seed default admin user if table is empty.
  void _seed() {
    final countResult = db.select('SELECT COUNT(*) as c FROM users');
    final count = countResult.first['c'] as int;
    if (count == 0) {
      // default credentials: admin@smartchuo.local / admin123
      final hash = _sha256('admin123');
      db.execute(
        'INSERT INTO users (email, password_hash, created_at) VALUES (?, ?, ?)',
        ['admin@smartchuo.local', hash, DateTime.now().millisecondsSinceEpoch],
      );
    }
  }

  /// Simple SHA256 hashing helper; keep it in DatabaseService to avoid extra utils file.
  String _sha256(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Close the database.
  void dispose() {
    _db?.dispose();
    _db = null;
  }
}
