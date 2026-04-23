import 'dart:convert';

import 'package:desarrollo_movil/models/api_colombia_item_model.dart';
import 'package:desarrollo_movil/models/endpoint_card_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiColombiaService {
  ApiColombiaService({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  static const List<EndpointCardModel> _endpoints = [
    EndpointCardModel(
      id: 'departments',
      title: 'Departamentos',
      description: 'Consulta de departamentos de Colombia.',
      iconName: 'map',
      path: '/api/v1/Department',
    ),
    EndpointCardModel(
      id: 'cities',
      title: 'Ciudades',
      description: 'Consulta de ciudades registradas.',
      iconName: 'location_city',
      path: '/api/v1/City',
    ),
    EndpointCardModel(
      id: 'regions',
      title: 'Regiones',
      description: 'Consulta de regiones del pais.',
      iconName: 'public',
      path: '/api/v1/Region',
    ),
    EndpointCardModel(
      id: 'touristic-attractions',
      title: 'Sitios Turisticos',
      description: 'Consulta de atractivos turisticos.',
      iconName: 'place',
      path: '/api/v1/TouristicAttraction',
    ),
  ];

  List<EndpointCardModel> getSelectedEndpoints() => _endpoints;

  EndpointCardModel? findById(String endpointId) {
    try {
      return _endpoints.firstWhere((item) => item.id == endpointId);
    } catch (_) {
      return null;
    }
  }

  Future<List<ApiColombiaItemModel>> fetchEndpointItems(String endpointId) async {
    final endpoint = findById(endpointId);
    if (endpoint == null) {
      throw Exception('Endpoint no configurado: $endpointId');
    }

    final baseUrl = dotenv.env['API_BASE_URL']?.trim().isNotEmpty == true
        ? dotenv.env['API_BASE_URL']!.trim()
        : 'https://api-colombia.com/';

    final uri = Uri.parse(baseUrl).resolve(endpoint.path.startsWith('/')
        ? endpoint.path.substring(1)
        : endpoint.path);

    final response = await _httpClient.get(uri);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Error ${response.statusCode} al consultar ${endpoint.path}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! List) {
      throw Exception('Formato de respuesta no valido para ${endpoint.path}');
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(ApiColombiaItemModel.fromJson)
        .toList();
  }
}
