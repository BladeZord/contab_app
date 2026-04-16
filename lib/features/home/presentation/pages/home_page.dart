import 'package:contab_app/core/constants/app_spacing.dart';
import 'package:contab_app/features/home/widgets/balance_card.dart';
import 'package:contab_app/features/home/widgets/quick_access_card.dart';
import 'package:contab_app/features/home/widgets/recent_activity_section.dart';
import 'package:contab_app/features/home/widgets/summary_section.dart';
import 'package:contab_app/features/tipo_movimiento/presentation/pages/tipo_movimiento_page.dart';
import 'package:contab_app/shared/widgets/app_shell.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Dashboard',
      currentIndex: 0,
      onTap: (index) {
        // navegación futura
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
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
          ),
          const SizedBox(height: AppSpacing.lg),
          const BalanceCard(),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Accesos rápidos',
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
                title: 'Tipos',
                subtitle: 'Tipos base',
                icon: Icons.swap_horiz_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TipoMovimientoPage(),
                    ),
                  );
                },
              ),
              QuickAccessCard(
                title: 'Categorías',
                subtitle: 'Organiza gastos',
                icon: Icons.category_rounded,
              ),
              QuickAccessCard(
                title: 'Cuentas',
                subtitle: 'Efectivo y banco',
                icon: Icons.account_balance_wallet_rounded,
              ),
              QuickAccessCard(
                title: 'Movimientos',
                subtitle: 'Ingresos y gastos',
                icon: Icons.receipt_long_rounded,
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
