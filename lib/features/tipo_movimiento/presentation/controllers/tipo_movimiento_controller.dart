import 'package:flutter/material.dart';
import '../../data/models/tipo_movimiento_model.dart';
import '../../data/repositories/tipo_movimiento_repository.dart';

class TipoMovimientoController extends ChangeNotifier {
  final TipoMovimientoRepository _repository;

  TipoMovimientoController({TipoMovimientoRepository? repository})
      : _repository = repository ?? TipoMovimientoRepository();

  final List<TipoMovimientoModel> _items = [];
  List<TipoMovimientoModel> get items => List.unmodifiable(_items);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> cargarTiposMovimiento() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _repository.listar();
      _items
        ..clear()
        ..addAll(data);
    } catch (e) {
      _error = 'Error al cargar tipos de movimiento';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> crearTipoMovimiento({
    required String nombre,
    String? descripcion,
  }) async {
    try {
      final ahora = DateTime.now().toIso8601String();

      final nuevo = TipoMovimientoModel(
        nombre: nombre.trim(),
        descripcion: descripcion?.trim().isEmpty == true
            ? null
            : descripcion?.trim(),
        fechaCreacion: ahora,
        fechaActualizacion: ahora,
      );

      await _repository.crear(nuevo);
      await cargarTiposMovimiento();
      return true;
    } catch (e) {
      _error = 'Error al crear tipo de movimiento';
      notifyListeners();
      return false;
    }
  }

  Future<bool> eliminarTipoMovimiento(int id) async {
    try {
      await _repository.eliminar(id);
      await cargarTiposMovimiento();
      return true;
    } catch (e) {
      _error = 'Error al eliminar tipo de movimiento';
      notifyListeners();
      return false;
    }
  }
}