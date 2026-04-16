import 'package:contab_app/core/utils/app_loading.dart';
import 'package:flutter/material.dart';
import '../controllers/tipo_movimiento_controller.dart';
import 'crear_tipo_movimiento_page.dart';

class TipoMovimientoPage extends StatefulWidget {
  const TipoMovimientoPage({super.key});

  @override
  State<TipoMovimientoPage> createState() => _TipoMovimientoPageState();
}

class _TipoMovimientoPageState extends State<TipoMovimientoPage> {
  late final TipoMovimientoController controller;

  @override
  void initState() {
    super.initState();
    controller = TipoMovimientoController();
    controller.addListener(_listener);
    controller.cargarTiposMovimiento();
  }

  void _listener() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(_listener);
    controller.dispose();
    super.dispose();
  }

  Future<void> _irACrear() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CrearTipoMovimientoPage(controller: controller),
      ),
    );

    await controller.cargarTiposMovimiento();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tipos de movimiento'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _irACrear,
        child: const Icon(Icons.add),
      ),
      body: Builder(
        builder: (_) {
          if (controller.isLoading) {
            return const AppLoading(
              message: 'Cargando tipos de movimiento...',
            );
          }

          if (controller.error != null) {
            return Center(child: Text(controller.error!));
          }

          if (controller.items.isEmpty) {
            return const Center(
              child: Text('No hay tipos de movimiento registrados'),
            );
          }

          return ListView.builder(
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              final item = controller.items[index];

              return ListTile(
                title: Text(item.nombre),
                subtitle: Text(item.descripcion ?? 'Sin descripción'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await controller.eliminarTipoMovimiento(item.id!);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}