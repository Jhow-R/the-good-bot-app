import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database _database;
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get connection async {
    if (_database == null) {
      _database = await _createDatabase();
    }
    return _database;
  }

  Future<Database> _createDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'messages.db');
    var database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: _createTables,
    );
    return database;
  }

  void _createTables(Database database, int version) async {    
    await database.execute(
      '''
      CREATE TABLE Messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        text TEXT,
        name TEXT,
        messageType TEXT
      )
      ''',
    );
  }
}
