import 'package:flutter/material.dart';
import 'app_header.dart';
import 'responsive_container.dart';
/*
  * AppShell es un wiget que hace de menú inferior y contenedor para las páginas principales de la aplicación.
  * Presenta las opciones de navegación y un footer común, además de un header con el título de la página.
*/
class AppShell extends StatelessWidget {
  final String title;
  final Widget body;
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const AppShell({
    super.key,
    required this.title,
    required this.body,
    this.currentIndex = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: title),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ResponsiveContainer(
                child: body,
              ),
            ),
            //const AppFooter(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.cloud_sync_outlined),
            selectedIcon: Icon(Icons.cloud_sync),
            label: 'Sincronización',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}