// AuthRepository handles login/logout and session persistence using sqlite3.
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'dart:convert';

import '../db/database_service.dart';
import '../../domain/models/user.dart';

class AuthRepository {
  AuthRepository(this._db);

  final DatabaseService _db;

  /// Compute sha256 password hash in hex.
  String _hash(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Attempt to login. Returns User on success; throws on failure.
  Future<User> login({required String email, required String password}) async {
    final result = _db.db.select(
      'SELECT id, email, password_hash FROM users WHERE email = ?',
      [email],
    );
    if (result.isEmpty) {
      throw Exception('Invalid email or password');
    }
    final row = result.first;
    final stored = row['password_hash'] as String;
    if (stored != _hash(password)) {
      throw Exception('Invalid email or password');
    }

    // create a session token
    final token = _randomToken();
    _db.db.execute(
      'INSERT INTO sessions (user_id, token, created_at) VALUES (?, ?, ?)',
      [row['id'] as int, token, DateTime.now().millisecondsSinceEpoch],
    );

    return User(id: row['id'] as int, email: row['email'] as String);
  }

  /// Clear all sessions for a user (simple logout for demo purposes)
  Future<void> logout(int userId) async {
    _db.db.execute('DELETE FROM sessions WHERE user_id = ?', [userId]);
  }

  /// Get the most recent logged-in user if any.
  Future<User?> currentUser() async {
    final result = _db.db.select(
      'SELECT u.id, u.email FROM sessions s JOIN users u ON s.user_id = u.id ORDER BY s.created_at DESC LIMIT 1',
    );
    if (result.isEmpty) return null;
    final row = result.first;
    return User(id: row['id'] as int, email: row['email'] as String);
  }

  String _randomToken() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rng = Random.secure();
    return List.generate(32, (_) => chars[rng.nextInt(chars.length)]).join();
  }
}
