import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'equipo.dart';

class EquipoDatabase {
  static final EquipoDatabase instance = EquipoDatabase._internal();

  static Database? _database;

  EquipoDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'equipos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, _) async {
    return await db.execute('''
        CREATE TABLE ${EquipoFields.tableName} (
          ${EquipoFields.id} ${EquipoFields.idType},
          ${EquipoFields.name} ${EquipoFields.textType},
          ${EquipoFields.foundingYear} ${EquipoFields.intType},
          ${EquipoFields.lastCampDate} ${EquipoFields.dateType}
        )
      ''');
  }

  Future<EquipoModel> create(EquipoModel equipo) async {
    final db = await instance.database;
    final id = await db.insert(EquipoFields.tableName, equipo.toJson());
    return equipo.copy(id: id);
  }

  Future<EquipoModel> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      EquipoFields.tableName,
      columns: EquipoFields.values,
      where: '${EquipoFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return EquipoModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<EquipoModel>> readAll() async {
    final db = await instance.database;
    const orderBy = '${EquipoFields.lastCampDate} DESC';
    final result = await db.query(EquipoFields.tableName, orderBy: orderBy);
    return result.map((json) => EquipoModel.fromJson(json)).toList();
  }

  Future<int> update(EquipoModel equipo) async {
    final db = await instance.database;
    return db.update(
      EquipoFields.tableName,
      equipo.toJson(),
      where: '${EquipoFields.id} = ?',
      whereArgs: [equipo.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      EquipoFields.tableName,
      where: '${EquipoFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
