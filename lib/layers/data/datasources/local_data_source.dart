import 'dart:convert';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:path/path.dart';
import 'package:sensor_tracking_app/layers/data/models/log_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

abstract class LocalDataSource {
  Future<LogModel> getAndSaveLogLocal();

  Future<String> showLogs();

  Future<void> deleteLog(List<int> ids);

  Future<Database> dbOpen();
}

class LocalDataSourceImp implements LocalDataSource {
  @override
  Future<Database> dbOpen() async {
    return openDatabase(
      join(await getDatabasesPath(), 'loggie1_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE logs(id INTEGER PRIMARY KEY AUTOINCREMENT, reading REAL, readAt TEXT)',
        );
      },
      version: 1,
    );
  }

  @override
  Future<LogModel> getAndSaveLogLocal() async {
    final db = await dbOpen();

    final CompassEvent tmp = await FlutterCompass.events!.first;

    var fido = LogModel(
      reading: tmp.heading!,
      readAt: DateTime.now().toUtc().toString(),
    );

    await db.insert(
      'logs',
      fido.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return fido;
  }

  @override
  Future<String> showLogs() async {
    final db = await dbOpen();
    final List<Map<String, dynamic>> maps = await db.query(
      'logs',
      limit: 10,
    );
    List<LogModel> logs = List.generate(maps.length, (i) {
      return LogModel(
        id: maps[i]['id'] as int?,
        reading: maps[i]['reading'] as double,
        readAt: maps[i]['readAt'] as String,
      );
    });

    List<dynamic> jsonList = logs.map((log) => log.toMap()).toList();
    String jsonString = jsonEncode(jsonList);

    print(jsonString);
    return jsonString;
  }

  @override
  Future<void> deleteLog(List<int> ids) async {
    final db = await dbOpen();
    for (var id in ids) {
      await db.delete(
        'logs',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }
}
