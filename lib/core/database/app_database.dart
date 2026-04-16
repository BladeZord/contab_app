import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'contab_app.db');

    return openDatabase(
      path,
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (database, version) async {
        await _createTables(database);
      },
      onUpgrade: (database, oldVersion, newVersion) async {
        await _runMigrations(database, oldVersion, newVersion);
      },
    );
  }

  Future<void> _createTables(Database db) async {
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

    await db.execute('''
      CREATE TABLE categoria (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        descripcion TEXT,
        estado INTEGER NOT NULL DEFAULT 1,
        fecha_creacion TEXT NOT NULL,
        fecha_actualizacion TEXT NOT NULL
      )
    ''');

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

    await db.execute('''
      CREATE TABLE movimiento (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo_movimiento_id INTEGER NOT NULL,
        categoria_id INTEGER,
        cuenta_id INTEGER NOT NULL,
        monto REAL NOT NULL,
        descripcion TEXT,
        fecha TEXT NOT NULL,
        estado INTEGER NOT NULL DEFAULT 1,
        fecha_creacion TEXT NOT NULL,
        fecha_actualizacion TEXT NOT NULL,
        FOREIGN KEY (tipo_movimiento_id) REFERENCES tipo_movimiento(id),
        FOREIGN KEY (categoria_id) REFERENCES categoria(id),
        FOREIGN KEY (cuenta_id) REFERENCES cuenta(id)
      )
    ''');
  }

  Future<void> _runMigrations(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {}
}