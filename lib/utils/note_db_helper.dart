import 'package:flutter_note/entity/note.dart';
import 'package:sqflite/sqflite.dart';

// 数据库操作工具类
class NoteDbHelper {
  Database db;

  Future open(String path) async {
    // 打开/创建数据库
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          "create table notes (_id INTEGER primary key autoincrement,title TEXT not null,content TEXT not null,star INTEGER not null,time INTEGER not null,weather INTEGER not null)");
      print("Table is created");
    });
  }

  Future<Database> getDatabase() async {
    Database database = await db;
    return database;
  }

  // 增加一条数据
  Future<Note> insert(Note note) async {
    note.id = await db.insert("notes", note.toMap());
    return note;
  }

  // 通过ID查询一条数据
  Future<Note> getNoteById(int id) async {
    List<Map> maps = await db.query('notes',
        columns: [
          columnId,
          columnTitle,
          columnContent,
          columnTime,
          columnStar,
          columnWeather
        ],
        where: '_id = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Note.fromMap(maps.first);
    }
    return null;
  }

  // 通过关键字查询数据
  Future<List<Note>> getNoteByContent(String text) async {
    List<Note> _noteList = List();
    List<Map> maps = await db.query('notes',
        columns: [
          columnId,
          columnTitle,
          columnContent,
          columnTime,
          columnStar,
          columnWeather
        ],
        where: 'content like ? ORDER BY time ASC',
        whereArgs: ["%" + text + "%"]);
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        _noteList.add(Note.fromMap(maps.elementAt(i)));
      }
      return _noteList;
    }
    return null;
  }

  // 通过ID删除一条数据
  Future<int> deleteById(int id) async {
    return await db.delete('notes', where: '_id = ?', whereArgs: [id]);
  }

  // 更新数据
  Future<int> update(Note note) async {
    return await db
        .update('notes', note.toMap(), where: '_id = ?', whereArgs: [note.id]);
  }

  // 关闭数据库
  Future close() async => db.close();
}
