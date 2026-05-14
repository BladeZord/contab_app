import 'package:flutter/material.dart';

import '../controllers/configuracion_controller.dart';

class ConfiguracionPage extends StatelessWidget {
  final ConfiguracionController controller;

  const ConfiguracionPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final config = controller.configuracion;

    return Scaffold(
      appBar: AppBar(title: const Text('Configuracion')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: SwitchListTile(
              value: config.modoOscuro,
              title: const Text('Modo oscuro'),
              secondary: const Icon(Icons.dark_mode_outlined),
              onChanged: (value) => controller.actualizar(modoOscuro: value),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              value: config.notificacionesActivas,
              title: const Text('Notificaciones'),
              subtitle: const Text('Mostrar pagos proximos por vencer'),
              secondary: const Icon(Icons.notifications_outlined),
              onChanged: (value) =>
                  controller.actualizar(notificacionesActivas: value),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.event_note_outlined),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Avisar pagos con ${config.diasAvisoPago} dias',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    min: 1,
                    max: 15,
                    divisions: 14,
                    label: '${config.diasAvisoPago}',
                    value: config.diasAvisoPago.toDouble(),
                    onChanged: (value) =>
                        controller.actualizar(diasAvisoPago: value.round()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
