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
      version: 3, // Make sure the version is updated
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE moods (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userIndex INTEGER NOT NULL,
      date TEXT,
      color TEXT,
      mood TEXT,
      note TEXT,
      FOREIGN KEY (userIndex) REFERENCES users (id) ON DELETE CASCADE
    )
  ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add the userIndex column to the moods table
      await db.execute('''
      ALTER TABLE moods ADD COLUMN userIndex INTEGER NOT NULL DEFAULT 0;
    ''');
    }
  }

  Future<int> addMood(
    int userIndex,
    String date,
    String color,
    String mood,
    String note,
  ) async {
    final db = await database;

    try {
      // Log the data being inserted
      print({
        'userIndex': userIndex,
        'date': date,
        'color': color,
        'mood': mood,
        'note': note,
      });

      final result = await db.insert('moods', {
        'userIndex': userIndex,
        'date': date,
        'color': color,
        'mood': mood,
        'note': note,
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      return result;
    } catch (e) {
      print("Error adding mood: $e");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getMoods(int userIndex) async {
    final db = await database;

    try {
      return await db.query(
        'moods',
        where: 'userIndex = ?',
        whereArgs: [userIndex],
        orderBy: "date DESC",
      );
    } catch (e) {
      print("Error fetching moods: $e");
      return []; // Return an empty list if an error occurs
    }
  }

  Future<void> deleteMood(int userIndex, int id) async {
    final db = await database;
    await db.delete(
      'moods',
      where: 'userIndex = ? AND id = ?',
      whereArgs: [userIndex, id],
    );
  }

  Future<void> updateMood(
    int userIndex,
    int id,
    String color,
    String mood,
    String note,
  ) async {
    final db = await database;
    await db.update(
      'moods',
      {'color': color, 'mood': mood, 'note': note},
      where: 'userIndex = ? AND id = ?',
      whereArgs: [userIndex, id],
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

  Future<bool> doesDateExist(int userIndex, String dateTimeString) async {
    final db = await database;

    // Extract just the date portion (YYYY-MM-DD)
    final dateOnly = dateTimeString.split(' ')[0];

    try {
      // Query using LIKE to match just the date portion
      final result = await db.query(
        'moods',
        where: 'userIndex = ? AND date LIKE ?',
        whereArgs: [userIndex, '$dateOnly%'],
        limit: 1,
      );

      return result.isNotEmpty;
    } catch (e) {
      print("Error checking if date exists: $e");
      return false; // Return false if an error occurs
    }
  }

  Future<List<Map<String, dynamic>>> getLast7DaysMoods(int userIndex) async {
    final db = await database;
    return await db.rawQuery(
      "SELECT * FROM moods WHERE userIndex = ? AND date >= DATE('now', '-7 days')",
      [userIndex],
    );
  }

  Future<List<Map<String, dynamic>>> getLast30DaysMoods(int userIndex) async {
    final db = await database;
    return await db.rawQuery(
      "SELECT * FROM moods WHERE userIndex = ? AND date >= DATE('now', '-30 days')",
      [userIndex],
    );
  }
}
