class CategoriaModel {
  final int? id;
  final String nombre;
  final String? descripcion;
  final int estado;
  final String fechaCreacion;
  final String fechaActualizacion;

  CategoriaModel({
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

  factory CategoriaModel.fromMap(Map<String, dynamic> map) {
    return CategoriaModel(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      descripcion: map['descripcion'] as String?,
      estado: map['estado'] as int,
      fechaCreacion: map['fecha_creacion'] as String,
      fechaActualizacion: map['fecha_actualizacion'] as String,
    );
  }

  CategoriaModel copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    int? estado,
    String? fechaCreacion,
    String? fechaActualizacion,
  }) {
    return CategoriaModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      estado: estado ?? this.estado,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }
}