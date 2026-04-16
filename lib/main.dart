import 'package:contab_app/core/database/app_database.dart';
import 'package:contab_app/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:contab_app/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppDatabase.instance.db;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contab App',
      theme: AppTheme.light,
      home: const HomePage(),
    );
  }
}
