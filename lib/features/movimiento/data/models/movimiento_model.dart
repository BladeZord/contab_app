class MovimientoModel {
  final int? id;
  final String tipo;
  final int? tipoMovimientoId;
  final int? categoriaId;
  final int? cuentaId;
  final double monto;
  final String? descripcion;
  final String fecha;
  final String? fechaVencimiento;
  final bool pagado;
  final bool esCuentaPorPagar;
  final int estado;
  final String fechaCreacion;
  final String fechaActualizacion;

  const MovimientoModel({
    this.id,
    required this.tipo,
    this.tipoMovimientoId,
    this.categoriaId,
    this.cuentaId,
    required this.monto,
    this.descripcion,
    required this.fecha,
    this.fechaVencimiento,
    this.pagado = true,
    this.esCuentaPorPagar = false,
    this.estado = 1,
    required this.fechaCreacion,
    required this.fechaActualizacion,
  });

  bool get esIngreso => tipo == 'ingreso';
  bool get esEgreso => tipo == 'egreso';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo': tipo,
      'tipo_movimiento_id': tipoMovimientoId,
      'categoria_id': categoriaId,
      'cuenta_id': cuentaId,
      'monto': monto,
      'descripcion': descripcion,
      'fecha': fecha,
      'fecha_vencimiento': fechaVencimiento,
      'pagado': pagado ? 1 : 0,
      'es_cuenta_por_pagar': esCuentaPorPagar ? 1 : 0,
      'estado': estado,
      'fecha_creacion': fechaCreacion,
      'fecha_actualizacion': fechaActualizacion,
    };
  }

  factory MovimientoModel.fromMap(Map<String, dynamic> map) {
    return MovimientoModel(
      id: map['id'] as int?,
      tipo: map['tipo'] as String,
      tipoMovimientoId: map['tipo_movimiento_id'] as int?,
      categoriaId: map['categoria_id'] as int?,
      cuentaId: map['cuenta_id'] as int?,
      monto: (map['monto'] as num).toDouble(),
      descripcion: map['descripcion'] as String?,
      fecha: map['fecha'] as String,
      fechaVencimiento: map['fecha_vencimiento'] as String?,
      pagado: (map['pagado'] as int) == 1,
      esCuentaPorPagar: (map['es_cuenta_por_pagar'] as int) == 1,
      estado: map['estado'] as int,
      fechaCreacion: map['fecha_creacion'] as String,
      fechaActualizacion: map['fecha_actualizacion'] as String,
    );
  }

  MovimientoModel copyWith({
    int? id,
    String? tipo,
    int? tipoMovimientoId,
    int? categoriaId,
    int? cuentaId,
    double? monto,
    String? descripcion,
    String? fecha,
    String? fechaVencimiento,
    bool? pagado,
    bool? esCuentaPorPagar,
    int? estado,
    String? fechaCreacion,
    String? fechaActualizacion,
  }) {
    return MovimientoModel(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      tipoMovimientoId: tipoMovimientoId ?? this.tipoMovimientoId,
      categoriaId: categoriaId ?? this.categoriaId,
      cuentaId: cuentaId ?? this.cuentaId,
      monto: monto ?? this.monto,
      descripcion: descripcion ?? this.descripcion,
      fecha: fecha ?? this.fecha,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
      pagado: pagado ?? this.pagado,
      esCuentaPorPagar: esCuentaPorPagar ?? this.esCuentaPorPagar,
      estado: estado ?? this.estado,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }
}
