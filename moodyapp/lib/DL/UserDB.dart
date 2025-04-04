import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabase {
  // Singleton instance
  static final UserDatabase instance = UserDatabase._init();

  // Private constructor
  UserDatabase._init();

  // Database instance
  static Database? _database;

  // Getter for the database
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initializeDB('User.db');
    return _database!;
  }

  // Initialize the database
  Future<Database> _initializeDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);
    return await openDatabase(
      path,
      version: 2, // Increment version when schema changes
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  // Create the database schema
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }

  // Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Handle any database schema updates here if necessary
    }
  }

  // Check if the username already exists in the database
  Future<bool> doesUsernameExist(String username) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  // Check if the email already exists in the database
  Future<bool> doesEmailExist(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  // Add a new user to the database
  Future<int> addUser(String username, String email, String password) async {
    final db = await database;

    // Check if username or email already exists
    bool usernameExists = await doesUsernameExist(username);
    bool emailExists = await doesEmailExist(email);

    if (usernameExists) {
      throw Exception("Username already exists");
    } else if (emailExists) {
      throw Exception("Email already exists");
    }

    try {
      final result = await db.insert('users', {
        'username': username,
        'email': email,
        'password': password,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      return result;
    } catch (e) {
      print("Error adding user: $e");
      rethrow;
    }
  }

  // Get all users from the database
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users', orderBy: "id DESC");
  }

  // Delete a user by ID
  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // Update a user's information
  Future<void> updateUser(
    int id,
    String username,
    String email,
    String password,
  ) async {
    final db = await database;
    await db.update(
      'users',
      {'username': username, 'email': email, 'password': password},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete all users from the database
  Future<void> deleteAllUsers() async {
    final db = await database;
    await db.delete('users');
  }

  // Delete the database file
  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'User.db');
    await deleteDatabase(path); // Deletes the old database
    print("Old database deleted");
  }

  // Get a user by username
  Future<List<Map<String, dynamic>>> getUserByUsername(String username) async {
    final db = await database;
    return await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
  }

  // Add this method to the UserDatabase class
  Future<bool> checkUsernameAndPassword(
    String username,
    String password,
  ) async {
    final db = await database;

    // Query the database for a user with the given username and password
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
      limit: 1, // Limit the result to one user
    );

    // Return true if a matching user is found, otherwise false
    return result.isNotEmpty;
  }

  // Add this method to the UserDatabase class
  Future<int?> getUserIndex(String username) async {
    final db = await database;

    // Query the database for the user with the given username
    final result = await db.query(
      'users',
      columns: ['id'], // Only retrieve the 'id' column
      where: 'username = ?',
      whereArgs: [username],
      limit: 1, // Limit the result to one user
    );

    // If a matching user is found, return their ID, otherwise return null
    if (result.isNotEmpty) {
      return result.first['id'] as int;
    } else {
      return null;
    }
  }

  // Add this method to the UserDatabase class
  Future<String?> getUsernameFromIndex(int userIndex) async {
    final db = await database;

    // Query the database for the user with the given ID
    final result = await db.query(
      'users',
      columns: ['username'], // Only retrieve the 'username' column
      where: 'id = ?',
      whereArgs: [userIndex],
      limit: 1, // Limit the result to one user
    );

    // If a matching user is found, return their username, otherwise return null
    if (result.isNotEmpty) {
      return result.first['username'] as String;
    } else {
      return null;
    }
  }

  // Add this method to the UserDatabase class
  Future<void> changePasswordById(int userId, String newPassword) async {
    final db = await database;

    // Update the password for the user with the given ID
    final result = await db.update(
      'users',
      {'password': newPassword},
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (result == 0) {
      throw Exception("Failed to update password. User ID not found.");
    }
  }
}
