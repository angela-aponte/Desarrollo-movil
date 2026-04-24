import 'package:desarrollo_movil/config/app_config.dart';
import 'package:desarrollo_movil/models/accident_record_model.dart';
import 'package:dio/dio.dart';

class AccidentService {
  AccidentService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<List<AccidentRecordModel>> fetchAccidents({
    int limit = 100000,
  }) async {
    final response = await _dio.get<dynamic>(
      AppConfig.accidentsApiBaseUrl,
      queryParameters: {'\$limit': limit},
    );

    if (response.data is! List) {
      throw Exception('Formato invalido en la respuesta de accidentes');
    }

    final decoded = response.data as List;

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(AccidentRecordModel.fromJson)
        .toList();
  }
}
