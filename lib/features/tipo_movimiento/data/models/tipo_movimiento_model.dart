class TipoMovimientoModel {
  final int? id;
  final String nombre;
  final String? descripcion;
  final int estado;
  final String fechaCreacion;
  final String fechaActualizacion;

  TipoMovimientoModel({
    this.id,
    required this.nombre,
    this.descripcion,
    this.estado = 1,
    required this.fechaCreacion,
    required this.fechaActualizacion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'estado': estado,
      'fecha_creacion': fechaCreacion,
      'fecha_actualizacion': fechaActualizacion,
    };
  }

  factory TipoMovimientoModel.fromMap(Map<String, dynamic> map) {
    return TipoMovimientoModel(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      descripcion: map['descripcion'] as String?,
      estado: map['estado'] as int,
      fechaCreacion: map['fecha_creacion'] as String,
      fechaActualizacion: map['fecha_actualizacion'] as String,
    );
  }

  TipoMovimientoModel copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    int? estado,
    String? fechaCreacion,
    String? fechaActualizacion,
  }) {
    return TipoMovimientoModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      estado: estado ?? this.estado,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }
}