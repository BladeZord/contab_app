import 'package:contab_app/core/utils/loading_utils.dart';
import 'package:flutter/material.dart';
import '../controllers/tipo_movimiento_controller.dart';

class CrearTipoMovimientoPage extends StatefulWidget {
  final TipoMovimientoController controller;

  const CrearTipoMovimientoPage({super.key, required this.controller});

  @override
  State<CrearTipoMovimientoPage> createState() =>
      _CrearTipoMovimientoPageState();
}

class _CrearTipoMovimientoPageState extends State<CrearTipoMovimientoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();

  static const bool _guardando = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    LoadingUtils.show(context, message: 'Guardando tipo de movimiento...');

    bool ok = false;

    try {
      ok = await widget.controller.crearTipoMovimiento(
        nombre: _nombreController.text,
        descripcion: _descripcionController.text,
      );
    } finally {
      if (mounted) {
        LoadingUtils.hide(context);
      }
    }

    if (!mounted) return;

    if (ok) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tipo de movimiento creado')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No se pudo guardar')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear tipo de movimiento')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _guardando ? null : _guardar,
                  child: Text(_guardando ? 'Guardando...' : 'Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
