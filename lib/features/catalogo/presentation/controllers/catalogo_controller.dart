import 'package:contab_app/features/categoria/data/models/categoria_model.dart';
import 'package:contab_app/features/categoria/data/repositories/categoria_repository.dart';
import 'package:flutter/material.dart';

class CatalogoController extends ChangeNotifier {
  final CategoriaRepository _repository;

  CatalogoController({CategoriaRepository? repository})
    : _repository = repository ?? CategoriaRepository();

  final List<CategoriaModel> _items = [];
  List<CategoriaModel> get items => List.unmodifiable(_items);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> cargar() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _repository.listarTodas();
      _items
        ..clear()
        ..addAll(data);
    } catch (_) {
      _error = 'No se pudieron cargar los catalogos';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> crear({
    required String nombre,
    String? descripcion,
    int? categoriaPadreId,
  }) async {
    try {
      final ahora = DateTime.now().toIso8601String();
      await _repository.crear(
        CategoriaModel(
          nombre: nombre.trim(),
          descripcion: descripcion?.trim().isEmpty == true
              ? null
              : descripcion?.trim(),
          categoriaPadreId: categoriaPadreId,
          fechaCreacion: ahora,
          fechaActualizacion: ahora,
        ),
      );
      await cargar();
      return true;
    } catch (_) {
      _error = 'No se pudo guardar el catalogo';
      notifyListeners();
      return false;
    }
  }

  Future<bool> eliminar(int id) async {
    try {
      await _repository.eliminar(id);
      await cargar();
      return true;
    } catch (_) {
      _error = 'No se pudo eliminar el catalogo';
      notifyListeners();
      return false;
    }
  }
}
