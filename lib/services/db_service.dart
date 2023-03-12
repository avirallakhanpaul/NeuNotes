import 'package:neunotes/models/note_model.dart';
import 'package:sqflite/sqflite.dart';

class DbService {
  static Database? _db;
  static const _version = 1;
  static const _tableName = "notes";

  static Future<void> initDb() async {
    if (_db != null) return;

    try {
      String path = "${await getDatabasesPath()}notes.db";
      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE $_tableName("
            "id STRING PRIMARY KEY , "
            "title STRING ,"
            "description TEXT , "
            "color INTEGER "
            ")",
          );
        },
      );
    } catch (e) {
      return;
    }
  }

  static Future<void> insertToDb(Note note) async {
    await _db?.insert(_tableName, note.toJson(note));
  }

  static Future<List<Map<String, Object?>>> query() async {
    return await _db!.query(_tableName);
  }

  static Future<void> delete(Note note) async {
    _db?.delete(
      _tableName,
      where: "id = ?",
      whereArgs: [note.id],
    );
  }

  static Future<void> deleteAll() async {
    _db?.delete(_tableName);
  }

  static Future<void> update(Note note) async {
    await _db?.update(
      _tableName,
      {
        "title": note.title,
        "description": note.description,
        "color": note.color,
      },
      where: "id = ?",
      whereArgs: [note.id],
    );
  }
}
