import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'Emotion.dart';

class SQLiteDbProvider {
  SQLiteDbProvider._();

  static final SQLiteDbProvider db = SQLiteDbProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "EmotionDB2.db");
    return await openDatabase(
        path, version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE Emotion(""id INTEGER PRIMARY KEY,"
                  "amount REAL,"
                  "date TEXT,"
                  "category TEXT"")"
          );
          await db.execute(
              "INSERT INTO Emotion ('id', 'amount', 'date', 'category') values(?, ?, ?, ?)",
              [1, 1000, '2019-04-01 10:00:00', "Food"]
          );
        }
    );
  }

  Future<List<Emotion>> getAllEmotions() async {
    final db = await database;
    List<Map> results = await db.query (
      "Emotion", columns: Emotion.columns, orderBy: "date DESC"
    );
    List<Emotion> emotions = new List();
    results.forEach((result) {
      Emotion emotion = Emotion.fromMap(result);
      emotions.add(emotion);
    });
    return emotions;
  }

  Future<Emotion> getEmotionById(int id) async {
    final db = await database;
    var result = await db.query("Emotion", where: "id = ", whereArgs: [id]);
    return result.isNotEmpty ? Emotion.fromMap(result.first) : Null;
  }

  Future<Emotion> insert(Emotion emotion) async {
    final db = await database;
    var maxIdResult = await db.rawQuery(
      "SELECT MAX(id)+1 as last_inserted_id FROM Emotion"
    );
    var id = maxIdResult.first["last_inserted_id"];
    var result = await db.rawInsert(
      "INSERT Into Emotion (id, amount, date, category)"
          "VALUES (?,?,?,?)", [
            id, emotion.amount, emotion.date.toString(), emotion.category
      ]
    );
    return Emotion(id, emotion.amount, emotion.date, emotion.category);
  }

  update(Emotion product) async {
    final db = await database;
    var result = await db.update(
      "Emotion", product.toMap(), where: "id = ?", whereArgs: [product.id]
    );
    return result;
  }

  delete(int id) async {
    final db = await database;
    db.delete("Emotion", where: "id = ?", whereArgs: [id]);
  }
}