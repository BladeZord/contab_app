
import 'package:contab_app/core/database/app_database.dart';
import 'package:contab_app/features/categoria/data/models/categoria_model.dart';
import 'package:sqflite/sqflite.dart';

class CategoriaRepository {
  final AppDatabase _appDatabase;
  //Constructor con inyección de dependencia para facilitar pruebas unitarias
  CategoriaRepository({AppDatabase? appDatabase})
      : _appDatabase = appDatabase ?? AppDatabase.instance;
  
  Future<int> crear(CategoriaModel tipo) async {
    final db = await _appDatabase.db;
    return await db.insert(
      'tipo_movimiento',
      tipo.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CategoriaModel>> listar() async {
    final db = await _appDatabase.db;

    final result = await db.query(
      'tipo_movimiento',
      orderBy: 'id DESC',
    );

    return result.map(CategoriaModel.fromMap).toList();
  }

   Future<CategoriaModel?> obtenerPorId(int id) async {
    final db = await _appDatabase.db;

    final result = await db.query(
      'tipo_movimiento',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return CategoriaModel.fromMap(result.first);
  }

  Future<int> actualizar(CategoriaModel tipo) async {
    final db = await _appDatabase.db;

    if (tipo.id == null) {
      throw Exception('No se puede actualizar un tipo_movimiento sin id');
    }

    return await db.update(
      'tipo_movimiento',
      tipo.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [tipo.id],
    );
  }

  Future<int> eliminar(int id) async {
    final db = await _appDatabase.db;

    return await db.delete(
      'tipo_movimiento',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}