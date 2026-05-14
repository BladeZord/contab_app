import 'package:contab_app/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';

import 'info_card.dart';

class SummarySection extends StatelessWidget {
  const SummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: InfoCard(
            title: 'Este mes',
            value: '24 movimientos',
            icon: Icons.calendar_month_rounded,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: InfoCard(
            title: 'Mayor gasto',
            value: 'Alimentación',
            icon: Icons.pie_chart_rounded,
          ),
        ),
      ],
    );
  }
}
