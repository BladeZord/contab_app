class ConfiguracionModel {
  final bool modoOscuro;
  final bool notificacionesActivas;
  final int diasAvisoPago;
  final String fechaActualizacion;

  const ConfiguracionModel({
    required this.modoOscuro,
    required this.notificacionesActivas,
    required this.diasAvisoPago,
    required this.fechaActualizacion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': 1,
      'modo_oscuro': modoOscuro ? 1 : 0,
      'notificaciones_activas': notificacionesActivas ? 1 : 0,
      'dias_aviso_pago': diasAvisoPago,
      'fecha_actualizacion': fechaActualizacion,
    };
  }

  factory ConfiguracionModel.fromMap(Map<String, dynamic> map) {
    return ConfiguracionModel(
      modoOscuro: (map['modo_oscuro'] as int) == 1,
      notificacionesActivas: (map['notificaciones_activas'] as int) == 1,
      diasAvisoPago: map['dias_aviso_pago'] as int,
      fechaActualizacion: map['fecha_actualizacion'] as String,
    );
  }

  factory ConfiguracionModel.inicial() {
    return ConfiguracionModel(
      modoOscuro: false,
      notificacionesActivas: true,
      diasAvisoPago: 3,
      fechaActualizacion: DateTime.now().toIso8601String(),
    );
  }

  ConfiguracionModel copyWith({
    bool? modoOscuro,
    bool? notificacionesActivas,
    int? diasAvisoPago,
    String? fechaActualizacion,
  }) {
    return ConfiguracionModel(
      modoOscuro: modoOscuro ?? this.modoOscuro,
      notificacionesActivas:
          notificacionesActivas ?? this.notificacionesActivas,
      diasAvisoPago: diasAvisoPago ?? this.diasAvisoPago,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }
}
