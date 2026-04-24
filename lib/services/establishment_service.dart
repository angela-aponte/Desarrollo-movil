import 'package:desarrollo_movil/config/app_config.dart';
import 'package:desarrollo_movil/models/establishment_model.dart';
import 'package:dio/dio.dart';

class EstablishmentService {
  EstablishmentService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  String _buildUrl(String path) {
    final base = AppConfig.parkingApiBaseUrl;
    final normalizedBase = base.endsWith('/') ? base : '$base/';
    return Uri.parse(normalizedBase)
        .resolve(path.startsWith('/') ? path.substring(1) : path)
        .toString();
  }

  Future<List<EstablishmentModel>> fetchAll() async {
    final response = await _dio.get<dynamic>(_buildUrl('/establecimientos'));
    final decoded = _extractList(response.data);
    if (decoded == null) {
      throw Exception('Formato invalido en establecimientos');
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(EstablishmentModel.fromJson)
        .toList();
  }

  Future<EstablishmentModel?> fetchById(String id) async {
    try {
      final response = await _dio.get<dynamic>(_buildUrl('/establecimientos/$id'));
      final map = _extractMap(response.data);
      if (map == null) {
        return null;
      }
      return EstablishmentModel.fromJson(map);
    } on DioException {
      return null;
    }
  }

  Future<EstablishmentModel?> create({
    required String nombre,
    required String nit,
    required String direccion,
    required String telefono,
    String? logoPath,
  }) async {
    final payload = <String, dynamic>{
      'nombre': nombre,
      'nit': nit,
      'direccion': direccion,
      'telefono': telefono,
    };
    if (logoPath != null && logoPath.isNotEmpty) {
      payload['logo'] = await MultipartFile.fromFile(logoPath);
    }

    final response = await _dio.post<dynamic>(
      _buildUrl('/establecimientos'),
      data: FormData.fromMap(payload),
      options: Options(contentType: 'multipart/form-data'),
    );

    final map = _extractMap(response.data);
    return map == null ? null : EstablishmentModel.fromJson(map);
  }

  Future<EstablishmentModel?> update({
    required String id,
    required String nombre,
    required String nit,
    required String direccion,
    required String telefono,
    String? logoPath,
  }) async {
    final payload = <String, dynamic>{
      '_method': 'PUT',
      'nombre': nombre,
      'nit': nit,
      'direccion': direccion,
      'telefono': telefono,
    };
    if (logoPath != null && logoPath.isNotEmpty) {
      payload['logo'] = await MultipartFile.fromFile(logoPath);
    }

    final response = await _dio.post<dynamic>(
      _buildUrl('/establecimientos/$id'),
      data: FormData.fromMap(payload),
      options: Options(contentType: 'multipart/form-data'),
    );

    final map = _extractMap(response.data);
    return map == null ? null : EstablishmentModel.fromJson(map);
  }

  Future<bool> delete(String id) async {
    try {
      await _dio.delete<dynamic>(_buildUrl('/establecimientos/$id'));
      return true;
    } on DioException {
      return false;
    }
  }

  List<dynamic>? _extractList(dynamic data) {
    if (data is List) {
      return data;
    }
    if (data is Map<String, dynamic> && data['data'] is List) {
      return data['data'] as List<dynamic>;
    }
    return null;
  }

  Map<String, dynamic>? _extractMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic>) {
        return data['data'] as Map<String, dynamic>;
      }
      return data;
    }
    return null;
  }
}
