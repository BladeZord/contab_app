import 'package:contab_app/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';

import 'mini_metric.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4F46E5),
            Color(0xFF6366F1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Saldo actual',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            '\$ 12,450.00',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: MiniMetric(
                  label: 'Ingresos',
                  value: '\$ 5,200',
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: MiniMetric(
                  label: 'Gastos',
                  value: '\$ 2,830',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}