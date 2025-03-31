import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mood_log.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE mood_entries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            color TEXT,
            mood TEXT,
            time TEXT,
            note TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertMood(Map<String, dynamic> mood) async {
    final db = await database;
    return await db.insert('mood_entries', mood);
  }

  Future<List<Map<String, dynamic>>> getMoods() async {
    final db = await database;
    return await db.query('mood_entries');
  }

  Future<int> updateMood(int id, Map<String, dynamic> mood) async {
    final db = await database;
    return await db.update(
      'mood_entries',
      mood,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteMood(int id) async {
    final db = await database;
    return await db.delete('mood_entries', where: 'id = ?', whereArgs: [id]);
  }
}
