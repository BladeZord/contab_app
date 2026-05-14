import 'package:flutter/material.dart';

import '../../data/models/movimiento_model.dart';
import '../../data/repositories/movimiento_repository.dart';

class MovimientoController extends ChangeNotifier {
  final MovimientoRepository _repository;

  MovimientoController({MovimientoRepository? repository})
    : _repository = repository ?? MovimientoRepository();

  final List<MovimientoModel> _items = [];
  List<MovimientoModel> get items => List.unmodifiable(_items);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> cargar({String? tipo}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _repository.listar(tipo: tipo);
      _items
        ..clear()
        ..addAll(data);
    } catch (_) {
      _error = 'No se pudieron cargar los movimientos';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cargarPagosProximos(int diasAviso) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _repository.listarPagosProximos(diasAviso);
      _items
        ..clear()
        ..addAll(data);
    } catch (_) {
      _error = 'No se pudieron cargar las notificaciones';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> crear({
    required String tipo,
    int? categoriaId,
    required double monto,
    String? descripcion,
    required DateTime fecha,
    DateTime? fechaVencimiento,
    bool esCuentaPorPagar = false,
  }) async {
    try {
      final ahora = DateTime.now().toIso8601String();
      await _repository.crear(
        MovimientoModel(
          tipo: tipo,
          categoriaId: categoriaId,
          monto: monto,
          descripcion: descripcion?.trim().isEmpty == true
              ? null
              : descripcion?.trim(),
          fecha: fecha.toIso8601String(),
          fechaVencimiento: fechaVencimiento?.toIso8601String(),
          pagado: !esCuentaPorPagar,
          esCuentaPorPagar: esCuentaPorPagar,
          fechaCreacion: ahora,
          fechaActualizacion: ahora,
        ),
      );
      await cargar(tipo: tipo);
      return true;
    } catch (_) {
      _error = 'No se pudo guardar el movimiento';
      notifyListeners();
      return false;
    }
  }

  Future<bool> marcarPagado(int id, int diasAviso) async {
    try {
      await _repository.marcarPagado(id);
      await cargarPagosProximos(diasAviso);
      return true;
    } catch (_) {
      _error = 'No se pudo marcar como pagado';
      notifyListeners();
      return false;
    }
  }

  Future<bool> eliminar(int id, {String? tipo}) async {
    try {
      await _repository.eliminar(id);
      await cargar(tipo: tipo);
      return true;
    } catch (_) {
      _error = 'No se pudo eliminar el movimiento';
      notifyListeners();
      return false;
    }
  }
}
