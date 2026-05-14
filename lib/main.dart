import 'package:contab_app/core/database/app_database.dart';
import 'package:contab_app/features/configuracion/presentation/controllers/configuracion_controller.dart';
import 'package:contab_app/features/home/presentation/pages/home_page.dart';
import 'package:contab_app/core/theme/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    debugPrint('Inicializando base de datos en Web');
    databaseFactory = databaseFactoryFfiWeb;
  } else if (_esPlataformaEscritorio()) {
    debugPrint('Inicializando base de datos en escritorio');
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await AppDatabase.instance.db;

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ConfiguracionController configuracionController;

  @override
  void initState() {
    super.initState();
    configuracionController = ConfiguracionController();
    configuracionController.addListener(_listener);
    configuracionController.cargar();
  }

  void _listener() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    configuracionController.removeListener(_listener);
    configuracionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contab App',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: configuracionController.themeMode,
      home: HomePage(configuracionController: configuracionController),
    );
  }
}

bool _esPlataformaEscritorio() {
  return defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS;
}
