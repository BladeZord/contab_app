import 'package:contab_app/core/utils/app_loading.dart';
import 'package:contab_app/features/configuracion/data/repositories/configuracion_repository.dart';
import 'package:contab_app/features/movimiento/presentation/controllers/movimiento_controller.dart';
import 'package:flutter/material.dart';

class NotificacionesPage extends StatefulWidget {
  const NotificacionesPage({super.key});

  @override
  State<NotificacionesPage> createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {
  final _configuracionRepository = ConfiguracionRepository();
  late final MovimientoController controller;
  int _diasAviso = 3;
  bool _notificacionesActivas = true;

  @override
  void initState() {
    super.initState();
    controller = MovimientoController();
    controller.addListener(_listener);
    _cargar();
  }

  void _listener() {
    if (mounted) setState(() {});
  }

  Future<void> _cargar() async {
    final config = await _configuracionRepository.obtener();
    _diasAviso = config.diasAvisoPago;
    _notificacionesActivas = config.notificacionesActivas;
    await controller.cargarPagosProximos(_diasAviso);
  }

  @override
  void dispose() {
    controller.removeListener(_listener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagos proximos')),
      body: Builder(
        builder: (_) {
          if (controller.isLoading) {
            return const AppLoading(message: 'Buscando pagos proximos...');
          }

          if (!_notificacionesActivas) {
            return const Center(
              child: Text('Las notificaciones estan desactivadas'),
            );
          }

          if (controller.items.isEmpty) {
            return Center(
              child: Text('No hay pagos por vencer en $_diasAviso dias'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final pago = controller.items[index];
              final vencimiento = DateTime.parse(pago.fechaVencimiento!);

              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.notifications_active_outlined),
                  ),
                  title: Text(pago.descripcion ?? 'Cuenta por pagar'),
                  subtitle: Text(
                    'Vence: ${vencimiento.day}/${vencimiento.month}/${vencimiento.year}',
                  ),
                  trailing: TextButton(
                    onPressed: () =>
                        controller.marcarPagado(pago.id!, _diasAviso),
                    child: const Text('Pagado'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
