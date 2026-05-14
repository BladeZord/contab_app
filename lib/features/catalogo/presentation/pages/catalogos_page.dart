import 'package:contab_app/core/utils/app_loading.dart';
import 'package:flutter/material.dart';

import '../../../categoria/data/models/categoria_model.dart';
import '../controllers/catalogo_controller.dart';

class CatalogosPage extends StatefulWidget {
  const CatalogosPage({super.key});

  @override
  State<CatalogosPage> createState() => _CatalogosPageState();
}

class _CatalogosPageState extends State<CatalogosPage> {
  late final CatalogoController controller;

  @override
  void initState() {
    super.initState();
    controller = CatalogoController();
    controller.addListener(_listener);
    controller.cargar();
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

  List<CategoriaModel> get _catalogos =>
      controller.items.where((item) => item.categoriaPadreId == null).toList();

  List<CategoriaModel> _subcatalogos(int catalogoId) {
    return controller.items
        .where((item) => item.categoriaPadreId == catalogoId)
        .toList();
  }

  Future<void> _abrirFormulario({CategoriaModel? padre}) async {
    final creado = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _CatalogoForm(
        catalogos: _catalogos,
        padre: padre,
        onGuardar: controller.crear,
      ),
    );

    if (creado == true && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Catalogo guardado')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catalogos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirFormulario,
        icon: const Icon(Icons.add),
        label: const Text('Catalogo'),
      ),
      body: Builder(
        builder: (_) {
          if (controller.isLoading) {
            return const AppLoading(message: 'Cargando catalogos...');
          }

          if (controller.error != null) {
            return Center(child: Text(controller.error!));
          }

          if (_catalogos.isEmpty) {
            return const Center(
              child: Text('Crea tu primer catalogo para clasificar datos'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _catalogos.length,
            itemBuilder: (context, index) {
              final catalogo = _catalogos[index];
              final hijos = _subcatalogos(catalogo.id!);

              return Card(
                child: ExpansionTile(
                  title: Text(catalogo.nombre),
                  subtitle: Text(catalogo.descripcion ?? 'Sin descripcion'),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  trailing: IconButton(
                    tooltip: 'Eliminar',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => controller.eliminar(catalogo.id!),
                  ),
                  children: [
                    if (hijos.isEmpty)
                      const ListTile(
                        dense: true,
                        title: Text('Sin subcatalogos'),
                      ),
                    for (final hijo in hijos)
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.subdirectory_arrow_right),
                        title: Text(hijo.nombre),
                        subtitle: Text(hijo.descripcion ?? 'Sin descripcion'),
                        trailing: IconButton(
                          tooltip: 'Eliminar',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => controller.eliminar(hijo.id!),
                        ),
                      ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => _abrirFormulario(padre: catalogo),
                        icon: const Icon(Icons.add),
                        label: const Text('Agregar subcatalogo'),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _CatalogoForm extends StatefulWidget {
  final List<CategoriaModel> catalogos;
  final CategoriaModel? padre;
  final Future<bool> Function({
    required String nombre,
    String? descripcion,
    int? categoriaPadreId,
  })
  onGuardar;

  const _CatalogoForm({
    required this.catalogos,
    required this.padre,
    required this.onGuardar,
  });

  @override
  State<_CatalogoForm> createState() => _CatalogoFormState();
}

class _CatalogoFormState extends State<_CatalogoForm> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  int? _padreId;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _padreId = widget.padre?.id;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);
    final ok = await widget.onGuardar(
      nombre: _nombreController.text,
      descripcion: _descripcionController.text,
      categoriaPadreId: _padreId,
    );

    if (!mounted) return;
    setState(() => _guardando = false);
    if (ok) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.padre == null ? 'Nuevo catalogo' : 'Nuevo subcatalogo',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 12),
            TextFormField(
              controller: _descripcionController,
              decoration: const InputDecoration(labelText: 'Descripcion'),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int?>(
              initialValue: _padreId,
              decoration: const InputDecoration(labelText: 'Catalogo padre'),
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text('Sin padre'),
                ),
                for (final catalogo in widget.catalogos)
                  DropdownMenuItem<int?>(
                    value: catalogo.id,
                    child: Text(catalogo.nombre),
                  ),
              ],
              onChanged: widget.padre == null
                  ? (value) => setState(() => _padreId = value)
                  : null,
            ),
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
    );
  }
}
