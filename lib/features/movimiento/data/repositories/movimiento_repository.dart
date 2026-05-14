import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../models/movimiento_model.dart';

class MovimientoRepository {
  final AppDatabase _appDatabase;

  MovimientoRepository({AppDatabase? appDatabase})
    : _appDatabase = appDatabase ?? AppDatabase.instance;

  Future<int> crear(MovimientoModel movimiento) async {
    final db = await _appDatabase.db;
    return db.insert(
      'movimiento',
      movimiento.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MovimientoModel>> listar({String? tipo}) async {
    final db = await _appDatabase.db;
    final result = await db.query(
      'movimiento',
      where: tipo == null ? null : 'tipo = ? AND estado = 1',
      whereArgs: tipo == null ? null : [tipo],
      orderBy: 'fecha DESC, id DESC',
    );

    return result.map(MovimientoModel.fromMap).toList();
  }

  Future<List<MovimientoModel>> listarPagosProximos(int diasAviso) async {
    final db = await _appDatabase.db;
    final hoy = DateTime.now();
    final limite = hoy.add(Duration(days: diasAviso));

    final result = await db.query(
      'movimiento',
      where: '''
        tipo = ?
        AND es_cuenta_por_pagar = 1
        AND pagado = 0
        AND fecha_vencimiento IS NOT NULL
        AND date(fecha_vencimiento) <= date(?)
        AND estado = 1
      ''',
      whereArgs: ['egreso', limite.toIso8601String()],
      orderBy: 'fecha_vencimiento ASC',
    );

    return result.map(MovimientoModel.fromMap).toList();
  }

  Future<double> totalPorTipo(String tipo) async {
    final db = await _appDatabase.db;
    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(monto), 0) AS total FROM movimiento WHERE tipo = ? AND estado = 1',
      [tipo],
    );

    return (result.first['total'] as num).toDouble();
  }

  Future<int> contar() async {
    final db = await _appDatabase.db;
    final result = await db.rawQuery(
      'SELECT COUNT(*) AS total FROM movimiento WHERE estado = 1',
    );

    return (result.first['total'] as int?) ?? 0;
  }

  Future<int> marcarPagado(int id) async {
    final db = await _appDatabase.db;
    return db.update(
      'movimiento',
      {'pagado': 1, 'fecha_actualizacion': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> eliminar(int id) async {
    final db = await _appDatabase.db;
    return db.update(
      'movimiento',
      {'estado': 0, 'fecha_actualizacion': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
