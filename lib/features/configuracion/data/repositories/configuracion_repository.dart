import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../models/configuracion_model.dart';

class ConfiguracionRepository {
  final AppDatabase _appDatabase;

  ConfiguracionRepository({AppDatabase? appDatabase})
    : _appDatabase = appDatabase ?? AppDatabase.instance;

  Future<ConfiguracionModel> obtener() async {
    final db = await _appDatabase.db;
    final result = await db.query(
      'configuracion',
      where: 'id = ?',
      whereArgs: [1],
    );

    if (result.isNotEmpty) {
      return ConfiguracionModel.fromMap(result.first);
    }

    final inicial = ConfiguracionModel.inicial();
    await guardar(inicial);
    return inicial;
  }

  Future<void> guardar(ConfiguracionModel configuracion) async {
    final db = await _appDatabase.db;
    await db.insert(
      'configuracion',
      configuracion.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
