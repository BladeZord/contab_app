import 'package:contab_app/core/constants/app_spacing.dart';
import 'package:contab_app/features/movimiento/data/repositories/movimiento_repository.dart';
import 'package:flutter/material.dart';

import 'mini_metric.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  final MovimientoRepository _repository = MovimientoRepository();
  late Future<_BalanceResumen> _resumenFuture;

  @override
  void initState() {
    super.initState();
    _resumenFuture = _cargarResumen();
  }

  Future<_BalanceResumen> _cargarResumen() async {
    final ingresos = await _repository.totalPorTipo('ingreso');
    final egresos = await _repository.totalPorTipo('egreso');

    return _BalanceResumen(
      ingresos: ingresos,
      egresos: egresos,
      saldo: ingresos - egresos,
    );
  }

  String _moneda(double valor) {
    final signo = valor < 0 ? '-' : '';
    return '$signo\$ ${valor.abs().toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_BalanceResumen>(
      future: _resumenFuture,
      builder: (context, snapshot) {
        final resumen = snapshot.data ?? _BalanceResumen.vacio();

        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Saldo actual',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (snapshot.connectionState == ConnectionState.waiting)
                const SizedBox(
                  height: 34,
                  width: 34,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                )
              else
                Text(
                  _moneda(resumen.saldo),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: MiniMetric(
                      label: 'Ingresos',
                      value: _moneda(resumen.ingresos),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: MiniMetric(
                      label: 'Gastos',
                      value: _moneda(resumen.egresos),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BalanceResumen {
  final double ingresos;
  final double egresos;
  final double saldo;

  const _BalanceResumen({
    required this.ingresos,
    required this.egresos,
    required this.saldo,
  });

  factory _BalanceResumen.vacio() {
    return const _BalanceResumen(ingresos: 0, egresos: 0, saldo: 0);
  }
}
