import 'package:contab_app/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';

import 'activity_tile.dart';

class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: const [
          ActivityTile(
            title: 'Compra en supermercado',
            subtitle: 'Hoy · Gasto',
            amount: '- \$45.00',
          ),
          Divider(),
          ActivityTile(
            title: 'Pago de salario',
            subtitle: 'Ayer · Ingreso',
            amount: '+ \$850.00',
          ),
          Divider(),
          ActivityTile(
            title: 'Recarga de transporte',
            subtitle: 'Ayer · Gasto',
            amount: '- \$12.00',
          ),
        ],
      ),
    );
  }
}