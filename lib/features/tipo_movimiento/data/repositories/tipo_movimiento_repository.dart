import 'package:sqflite/sqflite.dart';
import '../../../../core/database/app_database.dart';
import '../models/tipo_movimiento_model.dart';

class TipoMovimientoRepository {
  final AppDatabase _appDatabase;

  TipoMovimientoRepository({AppDatabase? appDatabase})
      : _appDatabase = appDatabase ?? AppDatabase.instance;

  Future<int> crear(TipoMovimientoModel tipo) async {
    final db = await _appDatabase.db;
    return await db.insert(
      'tipo_movimiento',
      tipo.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TipoMovimientoModel>> listar() async {
    final db = await _appDatabase.db;

    final result = await db.query(
      'tipo_movimiento',
      orderBy: 'id DESC',
    );

    return result.map(TipoMovimientoModel.fromMap).toList();
  }

  Future<TipoMovimientoModel?> obtenerPorId(int id) async {
    final db = await _appDatabase.db;

    final result = await db.query(
      'tipo_movimiento',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return TipoMovimientoModel.fromMap(result.first);
  }

  Future<int> actualizar(TipoMovimientoModel tipo) async {
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