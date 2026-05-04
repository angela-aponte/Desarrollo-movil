import 'dart:convert';

import 'package:desarrollo_movil/config/app_config.dart';
import 'package:desarrollo_movil/models/api_colombia_item_model.dart';
import 'package:desarrollo_movil/models/endpoint_detail_field_model.dart';
import 'package:desarrollo_movil/models/endpoint_card_model.dart';
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

  static const Map<String, List<EndpointDetailFieldModel>> _detailFields = {
    'departments': [
      EndpointDetailFieldModel(key: 'id', label: 'Id del departamento'),
      EndpointDetailFieldModel(key: 'name', label: 'Nombre'),
      EndpointDetailFieldModel(key: 'description', label: 'Descripción'),
      EndpointDetailFieldModel(
        key: 'cityCapitalId',
        label: 'Ciudad capital',
      ),
      EndpointDetailFieldModel(
        key: 'municipalities',
        label: 'Municipalidades',
      ),
      EndpointDetailFieldModel(key: 'surface', label: 'Superficie'),
      EndpointDetailFieldModel(key: 'population', label: 'Población'),
      EndpointDetailFieldModel(key: 'phonePrefix', label: 'Prefijo telefónico'),
    ],
    'cities': [
      EndpointDetailFieldModel(key: 'name', label: 'Nombre de la ciudad'),
      EndpointDetailFieldModel(key: 'departmentId', label: 'Departamento'),
      EndpointDetailFieldModel(key: 'description', label: 'Descripción'),
      EndpointDetailFieldModel(key: 'population', label: 'Población'),
      EndpointDetailFieldModel(key: 'latitude', label: 'Latitud'),
      EndpointDetailFieldModel(key: 'longitude', label: 'Longitud'),
    ],
    'regions': [
      EndpointDetailFieldModel(key: 'name', label: 'Nombre de la región'),
      EndpointDetailFieldModel(key: 'description', label: 'Descripción'),
      EndpointDetailFieldModel(key: 'code', label: 'Código'),
    ],
    'touristic-attractions': [
      EndpointDetailFieldModel(key: 'name', label: 'Nombre del sitio'),
      EndpointDetailFieldModel(key: 'description', label: 'Descripción'),
      EndpointDetailFieldModel(key: 'cityId', label: 'Ciudad'),
      EndpointDetailFieldModel(key: 'address', label: 'Dirección'),
    ],
  };

  List<EndpointCardModel> getSelectedEndpoints() => _endpoints;

  EndpointCardModel? findById(String endpointId) {
    try {
      return _endpoints.firstWhere((item) => item.id == endpointId);
    } catch (_) {
      return null;
    }
  }

  List<EndpointDetailFieldModel> getDetailFields(String endpointId) {
    return _detailFields[endpointId] ?? const [];
  }

  Future<String?> fetchCityNameById(int cityId) async {
    final uri = _buildUri('/api/v1/City/$cityId');
    final decoded = await _fetchSingleResource(uri);
    if (decoded == null) {
      return null;
    }

    final name = decoded['name'];
    if (name is String && name.trim().isNotEmpty) {
      return name;
    }

    final cityName = decoded['cityName'];
    if (cityName is String && cityName.trim().isNotEmpty) {
      return cityName;
    }

    return null;
  }

  Future<String?> fetchDepartmentNameById(int departmentId) async {
    final uri = _buildUri('/api/v1/Department/$departmentId');
    final decoded = await _fetchSingleResource(uri);
    if (decoded == null) {
      return null;
    }

    final name = decoded['name'];
    if (name is String && name.trim().isNotEmpty) {
      return name;
    }

    return null;
  }

  Future<Map<String, dynamic>?> _fetchSingleResource(Uri uri) async {
    final response = await _httpClient.get(uri);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return null;
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      return null;
    }

    return decoded;
  }

  Future<List<ApiColombiaItemModel>> fetchEndpointItems(String endpointId) async {
    final endpoint = findById(endpointId);
    if (endpoint == null) {
      throw Exception('Endpoint no configurado: $endpointId');
    }

    final uri = _buildUri(endpoint.path);

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

  Uri _buildUri(String path) {
    final baseUrl = AppConfig.apiBaseUrl;

    return Uri.parse(baseUrl).resolve(
      path.startsWith('/') ? path.substring(1) : path,
    );
  }
}
