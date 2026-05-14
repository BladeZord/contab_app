import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../models/categoria_model.dart';

class CategoriaRepository {
  final AppDatabase _appDatabase;

  CategoriaRepository({AppDatabase? appDatabase})
    : _appDatabase = appDatabase ?? AppDatabase.instance;

  Future<int> crear(CategoriaModel categoria) async {
    final db = await _appDatabase.db;
    return db.insert(
      'categoria',
      categoria.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CategoriaModel>> listar({int? categoriaPadreId}) async {
    final db = await _appDatabase.db;

    final result = await db.query(
      'categoria',
      where: categoriaPadreId == null
          ? 'categoria_padre_id IS NULL'
          : 'categoria_padre_id = ?',
      whereArgs: categoriaPadreId == null ? null : [categoriaPadreId],
      orderBy: 'nombre ASC',
    );

    return result.map(CategoriaModel.fromMap).toList();
  }

  Future<List<CategoriaModel>> listarTodas() async {
    final db = await _appDatabase.db;

    final result = await db.query(
      'categoria',
      orderBy: 'categoria_padre_id ASC, nombre ASC',
    );

    return result.map(CategoriaModel.fromMap).toList();
  }

  Future<CategoriaModel?> obtenerPorId(int id) async {
    final db = await _appDatabase.db;

    final result = await db.query(
      'categoria',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return CategoriaModel.fromMap(result.first);
  }

  Future<int> actualizar(CategoriaModel categoria) async {
    final db = await _appDatabase.db;

    if (categoria.id == null) {
      throw Exception('No se puede actualizar una categoria sin id');
    }

    return db.update(
      'categoria',
      categoria.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [categoria.id],
    );
  }

  Future<int> eliminar(int id) async {
    final db = await _appDatabase.db;

    return db.delete('categoria', where: 'id = ?', whereArgs: [id]);
  }
}
