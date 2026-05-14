import 'package:contab_app/core/utils/app_loading.dart';
import 'package:contab_app/features/categoria/data/models/categoria_model.dart';
import 'package:contab_app/features/categoria/data/repositories/categoria_repository.dart';
import 'package:flutter/material.dart';

import '../../data/models/movimiento_model.dart';
import '../controllers/movimiento_controller.dart';

class MovimientosPage extends StatefulWidget {
  final String tipo;

  const MovimientosPage({super.key, required this.tipo});

  @override
  State<MovimientosPage> createState() => _MovimientosPageState();
}

class _MovimientosPageState extends State<MovimientosPage> {
  late final MovimientoController controller;

  String get _titulo => widget.tipo == 'ingreso' ? 'Ingresos' : 'Egresos';

  @override
  void initState() {
    super.initState();
    controller = MovimientoController();
    controller.addListener(_listener);
    controller.cargar(tipo: widget.tipo);
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

  Future<void> _crear() async {
    final creado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CrearMovimientoPage(tipo: widget.tipo, controller: controller),
      ),
    );

    if (creado == true) {
      await controller.cargar(tipo: widget.tipo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titulo)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _crear,
        icon: const Icon(Icons.add),
        label: Text(widget.tipo == 'ingreso' ? 'Ingreso' : 'Egreso'),
      ),
      body: Builder(
        builder: (_) {
          if (controller.isLoading) {
            return AppLoading(message: 'Cargando $_titulo...');
          }

          if (controller.error != null) {
            return Center(child: Text(controller.error!));
          }

          if (controller.items.isEmpty) {
            return Center(child: Text('No hay $_titulo registrados'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = controller.items[index];
              return _MovimientoTile(
                movimiento: item,
                onEliminar: () =>
                    controller.eliminar(item.id!, tipo: widget.tipo),
              );
            },
          );
        },
      ),
    );
  }
}

class _MovimientoTile extends StatelessWidget {
  final MovimientoModel movimiento;
  final VoidCallback onEliminar;

  const _MovimientoTile({required this.movimiento, required this.onEliminar});

  @override
  Widget build(BuildContext context) {
    final fecha = DateTime.parse(movimiento.fecha);
    final color = movimiento.esIngreso ? Colors.green : Colors.red;
    final signo = movimiento.esIngreso ? '+' : '-';

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(
            movimiento.esIngreso
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            color: color,
          ),
        ),
        title: Text(movimiento.descripcion ?? 'Sin descripcion'),
        subtitle: Text(
          '${fecha.day}/${fecha.month}/${fecha.year}'
          '${movimiento.esCuentaPorPagar ? ' - Por pagar' : ''}',
        ),
        trailing: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              '$signo \$${movimiento.monto.toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.w700, color: color),
            ),
            IconButton(
              tooltip: 'Eliminar',
              icon: const Icon(Icons.delete_outline),
              onPressed: onEliminar,
            ),
          ],
        ),
      ),
    );
  }
}

class CrearMovimientoPage extends StatefulWidget {
  final String tipo;
  final MovimientoController controller;

  const CrearMovimientoPage({
    super.key,
    required this.tipo,
    required this.controller,
  });

  @override
  State<CrearMovimientoPage> createState() => _CrearMovimientoPageState();
}

class _CrearMovimientoPageState extends State<CrearMovimientoPage> {
  final _formKey = GlobalKey<FormState>();
  final _montoController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _categoriaRepository = CategoriaRepository();
  List<CategoriaModel> _categorias = [];
  int? _categoriaId;
  DateTime _fecha = DateTime.now();
  DateTime? _fechaVencimiento;
  bool _esCuentaPorPagar = false;
  bool _guardando = false;

  bool get _esEgreso => widget.tipo == 'egreso';

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
  }

  Future<void> _cargarCategorias() async {
    final categorias = await _categoriaRepository.listarTodas();
    if (mounted) {
      setState(() => _categorias = categorias);
    }
  }

  @override
  void dispose() {
    _montoController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha({required bool vencimiento}) async {
    final seleccion = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: vencimiento ? (_fechaVencimiento ?? _fecha) : _fecha,
    );

    if (seleccion == null || !mounted) return;
    setState(() {
      if (vencimiento) {
        _fechaVencimiento = seleccion;
      } else {
        _fecha = seleccion;
      }
    });
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);
    final monto = double.parse(_montoController.text.replaceAll(',', '.'));
    final ok = await widget.controller.crear(
      tipo: widget.tipo,
      categoriaId: _categoriaId,
      monto: monto,
      descripcion: _descripcionController.text,
      fecha: _fecha,
      fechaVencimiento: _esCuentaPorPagar ? _fechaVencimiento : null,
      esCuentaPorPagar: _esCuentaPorPagar,
    );

    if (!mounted) return;
    setState(() => _guardando = false);

    if (ok) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_esEgreso ? 'Egreso guardado' : 'Ingreso guardado'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final titulo = _esEgreso ? 'Crear egreso' : 'Crear ingreso';

    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _montoController,
                  decoration: const InputDecoration(
                    labelText: 'Monto',
                    prefixText: '\$ ',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    final monto = double.tryParse(
                      (value ?? '').replaceAll(',', '.'),
                    );
                    if (monto == null || monto <= 0) {
                      return 'Ingresa un monto valido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripcion'),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int?>(
                  initialValue: _categoriaId,
                  decoration: const InputDecoration(labelText: 'Catalogo'),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('Sin catalogo'),
                    ),
                    for (final categoria in _categorias)
                      DropdownMenuItem<int?>(
                        value: categoria.id,
                        child: Text(categoria.nombre),
                      ),
                  ],
                  onChanged: (value) => setState(() => _categoriaId = value),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Fecha'),
                  subtitle: Text(
                    '${_fecha.day}/${_fecha.month}/${_fecha.year}',
                  ),
                  trailing: const Icon(Icons.calendar_month_outlined),
                  onTap: () => _seleccionarFecha(vencimiento: false),
                ),
                if (_esEgreso) ...[
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _esCuentaPorPagar,
                    title: const Text('Cuenta por pagar'),
                    subtitle: const Text('Registrar vencimiento pendiente'),
                    onChanged: (value) {
                      setState(() {
                        _esCuentaPorPagar = value;
                        _fechaVencimiento ??= DateTime.now();
                      });
                    },
                  ),
                  if (_esCuentaPorPagar)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Fecha de vencimiento'),
                      subtitle: Text(
                        '${_fechaVencimiento!.day}/${_fechaVencimiento!.month}/${_fechaVencimiento!.year}',
                      ),
                      trailing: const Icon(Icons.event_available_outlined),
                      onTap: () => _seleccionarFecha(vencimiento: true),
                    ),
                ],
                const SizedBox(height: 20),
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
        ],
      ),
    );
  }
}
