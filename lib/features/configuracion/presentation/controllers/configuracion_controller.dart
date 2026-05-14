import 'package:flutter/material.dart';

import '../../data/models/configuracion_model.dart';
import '../../data/repositories/configuracion_repository.dart';

class ConfiguracionController extends ChangeNotifier {
  final ConfiguracionRepository _repository;

  ConfiguracionController({ConfiguracionRepository? repository})
    : _repository = repository ?? ConfiguracionRepository();

  ConfiguracionModel _configuracion = ConfiguracionModel.inicial();
  ConfiguracionModel get configuracion => _configuracion;

  ThemeMode get themeMode =>
      _configuracion.modoOscuro ? ThemeMode.dark : ThemeMode.light;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> cargar() async {
    _isLoading = true;
    notifyListeners();

    _configuracion = await _repository.obtener();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> actualizar({
    bool? modoOscuro,
    bool? notificacionesActivas,
    int? diasAvisoPago,
  }) async {
    _configuracion = _configuracion.copyWith(
      modoOscuro: modoOscuro,
      notificacionesActivas: notificacionesActivas,
      diasAvisoPago: diasAvisoPago,
      fechaActualizacion: DateTime.now().toIso8601String(),
    );
    notifyListeners();
    await _repository.guardar(_configuracion);
  }
}
