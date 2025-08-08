import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DbService {
  static Database? _db;

  static Future<DbService> init() async {
    final instance = DbService();
    await instance._open();
    return instance;
  }

  Future<void> _open() async {
    if (_db != null) return;
    
    // Initialize sqflite_ffi for desktop support
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'wisc.db');
    _db = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _ensureInitialized() async {
    if (_db == null) {
      await _open();
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE children(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT,
        lastName TEXT,
        dob TEXT,
        type TEXT DEFAULT 'child'
      )
    ''');

    await db.execute('''
      CREATE TABLE adults(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT,
        lastName TEXT,
        dob TEXT,
        type TEXT DEFAULT 'adult'
      )
    ''');

    await db.execute('''
      CREATE TABLE sessions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        childId INTEGER,
        adultId INTEGER,
        subtest TEXT,
        startedAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE answers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sessionId INTEGER,
        questionId INTEGER,
        score INTEGER,
        timeTaken INTEGER
      )
    ''');
  }

  Future<int> insertChild(Map<String, dynamic> child) async {
    await _ensureInitialized();
    return await _db!.insert('children', child);
  }

  Future<int> insertAdult(Map<String, dynamic> adult) async {
    await _ensureInitialized();
    return await _db!.insert('adults', adult);
  }

  Future<List<Map<String, dynamic>>> getChildren() async {
    await _ensureInitialized();
    return await _db!.query('children');
  }

  Future<List<Map<String, dynamic>>> getAdults() async {
    await _ensureInitialized();
    return await _db!.query('adults');
  }

  Future<int> createSession(int childId, String subtest) async {
    await _ensureInitialized();
    return await _db!.insert('sessions', {
      'childId': childId,
      'subtest': subtest,
      'startedAt': DateTime.now().toIso8601String()
    });
  }

  Future<int> createAdultSession(int adultId, String subtest) async {
    await _ensureInitialized();
    return await _db!.insert('sessions', {
      'adultId': adultId,
      'subtest': subtest,
      'startedAt': DateTime.now().toIso8601String()
    });
  }

  Future<int> insertAnswer(Map<String, dynamic> ans) async {
    await _ensureInitialized();
    return await _db!.insert('answers', ans);
  }

  Future<List<Map<String, dynamic>>> getAnswersForSession(int sessionId) async {
    await _ensureInitialized();
    return await _db!.query('answers', where: 'sessionId = ?', whereArgs: [sessionId]);
  }
}
