import 'package:sqflite/sqflite.dart';
import "package:path/path.dart";

Database? _database;

class LocalDatabase {
  Future get database async {
    if (_database != null) return _database;
    _database = await _initializeDB('Moody.db');
    return _database;
  }

  Future _initializeDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);
    return await openDatabase(
      path,
      version: 2, // Make sure the version is updated
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE moods (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        color TEXT,
        mood TEXT,
        note TEXT
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Ensure that 'mood' column is added in case the database version is updated
      await db.execute('''
        ALTER TABLE moods ADD COLUMN mood TEXT;
      ''');
    }
  }

  Future<int> addMood(
    String date,
    String color, // Color is already a string (hexadecimal format)
    String mood,
    String note,
  ) async {
    final db = await database;

    try {
      print("Adding mood: $date, $color, $mood, $note");
      final result = await db.insert('moods', {
        'date': date,
        'color': color, // Store the color as a string
        'mood': mood,
        'note': note,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      print("Mood added successfully, ID: $result");
      return result;
    } catch (e) {
      print("Error adding mood: $e");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getMoods() async {
    final db = await database;
    return await db.query('moods', orderBy: "date DESC"); // Sort by date
  }

  Future<void> deleteMood(int id) async {
    final db = await database;
    await db.delete('moods', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateMood(
    int id,
    String color,
    String mood,
    String note,
  ) async {
    final db = await database;
    await db.update(
      'moods',
      {'color': color, 'mood': mood, 'note': note},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllTestMoods() async {
    final db = await database;
    await db.delete(
      'moods',
    ); // This will delete all records from the moods table
  }

  // Call this method to delete the old database and re-create it
  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'Moody.db');
    await deleteDatabase(path); // Deletes the old database
    print("Old database deleted");
  }

  Future<bool> doesDateExist(String dateTimeString) async {
    final db = await database;

    // Extract just the date portion (YYYY-MM-DD)
    final dateOnly = dateTimeString.split(' ')[0];

    // Query using LIKE to match just the date portion
    final result = await db.query(
      'moods',
      where: 'date LIKE ?',
      whereArgs: ['$dateOnly%'], // Match any entries starting with this date
      limit: 1,
    );

    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getLast7DaysMoods() async {
    final db = await database;
    return await db.rawQuery(
      "SELECT * FROM moods WHERE date >= DATE('now', '-7 days')",
    );
  }

  Future<List<Map<String, dynamic>>> getLast30DaysMoods() async {
    final db = await database;
    return await db.rawQuery(
      "SELECT * FROM moods WHERE date >= DATE('now', '-30 days')",
    );
  }
}
