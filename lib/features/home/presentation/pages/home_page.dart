import 'package:contab_app/core/constants/app_spacing.dart';
import 'package:contab_app/features/catalogo/presentation/pages/catalogos_page.dart';
import 'package:contab_app/features/configuracion/presentation/controllers/configuracion_controller.dart';
import 'package:contab_app/features/configuracion/presentation/pages/configuracion_page.dart';
import 'package:contab_app/features/home/widgets/balance_card.dart';
import 'package:contab_app/features/home/widgets/quick_access_card.dart';
import 'package:contab_app/features/home/widgets/recent_activity_section.dart';
import 'package:contab_app/features/home/widgets/summary_section.dart';
import 'package:contab_app/features/movimiento/presentation/pages/movimientos_page.dart';
import 'package:contab_app/features/notificacion/presentation/pages/notificaciones_page.dart';
import 'package:contab_app/shared/widgets/app_shell.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final ConfiguracionController configuracionController;

  const HomePage({super.key, required this.configuracionController});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _balanceVersion = 0;

  Future<void> _abrir(BuildContext context, Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    if (mounted) {
      setState(() => _balanceVersion++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Dashboard',
      currentIndex: 0,
      onTap: (index) {
        if (index == 2) {
          _abrir(
            context,
            ConfiguracionPage(controller: widget.configuracionController),
          );
        }
      },
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Bienvenido',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Controla tus finanzas personales de forma simple.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          BalanceCard(key: ValueKey(_balanceVersion)),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Accesos rapidos',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.md),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.15,
            children: [
              QuickAccessCard(
                title: 'Catalogos',
                subtitle: 'Catalogos e hijos',
                icon: Icons.category_rounded,
                onTap: () => _abrir(context, const CatalogosPage()),
              ),
              QuickAccessCard(
                title: 'Ingresos',
                subtitle: 'Entradas de dinero',
                icon: Icons.trending_up_rounded,
                onTap: () =>
                    _abrir(context, const MovimientosPage(tipo: 'ingreso')),
              ),
              QuickAccessCard(
                title: 'Egresos',
                subtitle: 'Gastos y pagos',
                icon: Icons.trending_down_rounded,
                onTap: () =>
                    _abrir(context, const MovimientosPage(tipo: 'egreso')),
              ),
              QuickAccessCard(
                title: 'Alertas',
                subtitle: 'Pagos proximos',
                icon: Icons.notifications_active_rounded,
                onTap: () => _abrir(context, const NotificacionesPage()),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Resumen',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.md),
          const SummarySection(),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Actividad reciente',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.md),
          const RecentActivitySection(),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
