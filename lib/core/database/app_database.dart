import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final path = kIsWeb
        ? 'contab_app.db'
        : join(await getDatabasesPath(), 'contab_app.db');
    debugPrint('Abriendo DB en: $path');

    return openDatabase(
      path,
      version: 3,
      onConfigure: (database) async {
        debugPrint('onConfigure');
        if (!kIsWeb) {
          await database.execute('PRAGMA foreign_keys = ON');
        }
      },
      onCreate: (database, version) async {
        debugPrint('onCreate');

        await _createTables(database);
      },
      onUpgrade: (database, oldVersion, newVersion) async {
        debugPrint('onUpgrade: $oldVersion -> $newVersion');

        await _runMigrations(database, oldVersion, newVersion);
      },
    );
  }

  Future<void> _createTables(Database db) async {
    debugPrint('Creando tabla tipo_movimiento');

    await db.execute('''
      CREATE TABLE tipo_movimiento (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        descripcion TEXT,
        estado INTEGER NOT NULL DEFAULT 1,
        fecha_creacion TEXT NOT NULL,
        fecha_actualizacion TEXT NOT NULL
      )
    ''');
    debugPrint('Creando tabla categoria');

    await db.execute('''
      CREATE TABLE categoria (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        descripcion TEXT,
        categoria_padre_id INTEGER,
        estado INTEGER NOT NULL DEFAULT 1,
        fecha_creacion TEXT NOT NULL,
        fecha_actualizacion TEXT NOT NULL,
        FOREIGN KEY (categoria_padre_id) REFERENCES categoria(id)
      )
    ''');
    debugPrint('Creando tabla cuenta');
    await db.execute('''
      CREATE TABLE cuenta (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        tipo TEXT NOT NULL,
        saldo_inicial REAL NOT NULL DEFAULT 0,
        estado INTEGER NOT NULL DEFAULT 1,
        fecha_creacion TEXT NOT NULL,
        fecha_actualizacion TEXT NOT NULL
      )
    ''');
    debugPrint('Creando tabla movimiento');
    await db.execute('''
      CREATE TABLE movimiento (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo TEXT NOT NULL,
        tipo_movimiento_id INTEGER,
        categoria_id INTEGER,
        cuenta_id INTEGER,
        monto REAL NOT NULL,
        descripcion TEXT,
        fecha TEXT NOT NULL,
        fecha_vencimiento TEXT,
        pagado INTEGER NOT NULL DEFAULT 1,
        es_cuenta_por_pagar INTEGER NOT NULL DEFAULT 0,
        estado INTEGER NOT NULL DEFAULT 1,
        fecha_creacion TEXT NOT NULL,
        fecha_actualizacion TEXT NOT NULL,
        FOREIGN KEY (tipo_movimiento_id) REFERENCES tipo_movimiento(id),
        FOREIGN KEY (categoria_id) REFERENCES categoria(id),
        FOREIGN KEY (cuenta_id) REFERENCES cuenta(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE configuracion (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        modo_oscuro INTEGER NOT NULL DEFAULT 0,
        notificaciones_activas INTEGER NOT NULL DEFAULT 1,
        dias_aviso_pago INTEGER NOT NULL DEFAULT 3,
        fecha_actualizacion TEXT NOT NULL
      )
    ''');

    await _seedInitialData(db);
  }

  Future<void> _runMigrations(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await _migrateToV2(db);
    }
    if (oldVersion < 3) {
      await _migrateToV3(db);
    }
  }

  Future<void> _migrateToV2(Database db) async {
    final ahora = DateTime.now().toIso8601String();

    await db.execute(
      'ALTER TABLE categoria ADD COLUMN categoria_padre_id INTEGER',
    );

    await db.execute('''
      CREATE TABLE movimiento_nuevo (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo TEXT NOT NULL,
        tipo_movimiento_id INTEGER,
        categoria_id INTEGER,
        cuenta_id INTEGER,
        monto REAL NOT NULL,
        descripcion TEXT,
        fecha TEXT NOT NULL,
        fecha_vencimiento TEXT,
        pagado INTEGER NOT NULL DEFAULT 1,
        es_cuenta_por_pagar INTEGER NOT NULL DEFAULT 0,
        estado INTEGER NOT NULL DEFAULT 1,
        fecha_creacion TEXT NOT NULL,
        fecha_actualizacion TEXT NOT NULL,
        FOREIGN KEY (tipo_movimiento_id) REFERENCES tipo_movimiento(id),
        FOREIGN KEY (categoria_id) REFERENCES categoria(id),
        FOREIGN KEY (cuenta_id) REFERENCES cuenta(id)
      )
    ''');

    await db.execute('''
      INSERT INTO movimiento_nuevo (
        id,
        tipo,
        tipo_movimiento_id,
        categoria_id,
        cuenta_id,
        monto,
        descripcion,
        fecha,
        fecha_vencimiento,
        pagado,
        es_cuenta_por_pagar,
        estado,
        fecha_creacion,
        fecha_actualizacion
      )
      SELECT
        id,
        CASE
          WHEN tipo_movimiento_id = 1 THEN 'ingreso'
          ELSE 'egreso'
        END,
        tipo_movimiento_id,
        categoria_id,
        cuenta_id,
        monto,
        descripcion,
        fecha,
        NULL,
        1,
        0,
        estado,
        fecha_creacion,
        fecha_actualizacion
      FROM movimiento
    ''');

    await db.execute('DROP TABLE movimiento');
    await db.execute('ALTER TABLE movimiento_nuevo RENAME TO movimiento');

    await db.execute('''
      CREATE TABLE configuracion (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        modo_oscuro INTEGER NOT NULL DEFAULT 0,
        notificaciones_activas INTEGER NOT NULL DEFAULT 1,
        dias_aviso_pago INTEGER NOT NULL DEFAULT 3,
        fecha_actualizacion TEXT NOT NULL
      )
    ''');

    await db.insert('configuracion', {
      'id': 1,
      'modo_oscuro': 0,
      'notificaciones_activas': 1,
      'dias_aviso_pago': 3,
      'fecha_actualizacion': ahora,
    });
  }

  Future<void> _migrateToV3(Database db) async {
    await _seedDefaultCatalogs(db);
  }

  Future<void> _seedInitialData(Database db) async {
    final ahora = DateTime.now().toIso8601String();

    await db.insert('configuracion', {
      'id': 1,
      'modo_oscuro': 0,
      'notificaciones_activas': 1,
      'dias_aviso_pago': 3,
      'fecha_actualizacion': ahora,
    });

    await db.insert('cuenta', {
      'nombre': 'Efectivo',
      'tipo': 'efectivo',
      'saldo_inicial': 0,
      'estado': 1,
      'fecha_creacion': ahora,
      'fecha_actualizacion': ahora,
    });

    await _seedDefaultCatalogs(db);
  }

  Future<void> _seedDefaultCatalogs(Database db) async {
    await _insertCatalogWithChildren(
      db,
      nombre: 'Estados',
      descripcion: 'Estados generales para registros',
      hijos: ['Activo', 'Inactivo', 'Pendiente', 'Pagado'],
    );
    await _insertCatalogWithChildren(
      db,
      nombre: 'Tipos de cuenta',
      descripcion: 'Clasificacion de cuentas personales',
      hijos: ['Efectivo', 'Banco', 'Tarjeta de credito'],
    );
    await _insertCatalogWithChildren(
      db,
      nombre: 'Categorias financieras',
      descripcion: 'Clasificacion base para ingresos y egresos',
      hijos: ['Salario', 'Alimentacion', 'Transporte', 'Servicios'],
    );
  }

  Future<void> _insertCatalogWithChildren(
    Database db, {
    required String nombre,
    required String descripcion,
    required List<String> hijos,
  }) async {
    final existente = await db.query(
      'categoria',
      columns: ['id'],
      where: 'nombre = ? AND categoria_padre_id IS NULL',
      whereArgs: [nombre],
      limit: 1,
    );

    if (existente.isNotEmpty) return;

    final ahora = DateTime.now().toIso8601String();
    final catalogoId = await db.insert('categoria', {
      'nombre': nombre,
      'descripcion': descripcion,
      'categoria_padre_id': null,
      'estado': 1,
      'fecha_creacion': ahora,
      'fecha_actualizacion': ahora,
    });

    for (final hijo in hijos) {
      await db.insert('categoria', {
        'nombre': hijo,
        'descripcion': null,
        'categoria_padre_id': catalogoId,
        'estado': 1,
        'fecha_creacion': ahora,
        'fecha_actualizacion': ahora,
      });
    }
  }
}
