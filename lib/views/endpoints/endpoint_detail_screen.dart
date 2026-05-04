import 'package:desarrollo_movil/models/api_colombia_item_model.dart';
import 'package:desarrollo_movil/models/endpoint_card_model.dart';
import 'package:desarrollo_movil/models/endpoint_detail_field_model.dart';
import 'package:desarrollo_movil/services/api_colombia_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EndpointDetailScreen extends StatefulWidget {
  const EndpointDetailScreen({
    required this.endpoint,
    required this.item,
    super.key,
  });

  final EndpointCardModel endpoint;
  final ApiColombiaItemModel item;

  @override
  State<EndpointDetailScreen> createState() => _EndpointDetailScreenState();
}

class _EndpointDetailScreenState extends State<EndpointDetailScreen> {
  late final Future<String?> _capitalCityNameFuture;
  late final Future<String?> _cityDepartmentNameFuture;
  late final Future<String?> _touristicCityNameFuture;

  static final ApiColombiaService _apiService = ApiColombiaService();

  @override
  void initState() {
    super.initState();
    _capitalCityNameFuture = _loadCapitalCityName();
    _cityDepartmentNameFuture = _loadCityDepartmentName();
    _touristicCityNameFuture = _loadTouristicCityName();
  }

  @override
  Widget build(BuildContext context) {
    final fields = _apiService.getDetailFields(widget.endpoint.id);
    final labeledFields = fields.isNotEmpty
        ? fields
        : const [
            EndpointDetailFieldModel(key: 'title', label: 'Título'),
          ];

    return Scaffold(
      appBar: AppBar(title: Text('Detalle: ${widget.endpoint.title}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.item.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              widget.item.id != null ? 'ID: ${widget.item.id}' : 'Sin ID disponible',
            ),
            const SizedBox(height: 8),
            Text('Endpoint: ${widget.endpoint.path}'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver al listado'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: labeledFields.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final field = labeledFields[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(field.label),
                    subtitle: _buildFieldValue(field.key),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldValue(String key) {
    if (widget.endpoint.id == 'departments' && key == 'cityCapitalId') {
      return FutureBuilder<String?>(
        future: _capitalCityNameFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Consultando ciudad capital...');
          }

          final capitalName = snapshot.data;
          if (capitalName != null && capitalName.trim().isNotEmpty) {
            return Text(capitalName);
          }

          return Text(_resolveFieldValue(key));
        },
      );
    }

    if (widget.endpoint.id == 'cities' && key == 'departmentId') {
      return FutureBuilder<String?>(
        future: _cityDepartmentNameFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Consultando departamento...');
          }

          final departmentName = snapshot.data;
          if (departmentName != null && departmentName.trim().isNotEmpty) {
            return Text(departmentName);
          }

          return Text(_resolveFieldValue(key));
        },
      );
    }

    if (widget.endpoint.id == 'touristic-attractions' && key == 'cityId') {
      return FutureBuilder<String?>(
        future: _touristicCityNameFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Consultando ciudad...');
          }

          final cityName = snapshot.data;
          if (cityName != null && cityName.trim().isNotEmpty) {
            return Text(cityName);
          }

          return Text(_resolveFieldValue(key));
        },
      );
    }

    return Text(_resolveFieldValue(key));
  }

  String _resolveFieldValue(String key) {
    final value = widget.item.raw[key];
    if (value == null) {
      return 'No disponible';
    }

    if (value is String && value.trim().isEmpty) {
      return 'No disponible';
    }

    return value.toString();
  }

  Future<String?> _loadCapitalCityName() async {
    final rawId = widget.item.raw['cityCapitalId'];
    if (rawId == null) {
      return null;
    }

    final cityId = rawId is int ? rawId : int.tryParse('$rawId');
    if (cityId == null) {
      return null;
    }

    return _apiService.fetchCityNameById(cityId);
  }

  Future<String?> _loadCityDepartmentName() async {
    if (widget.endpoint.id != 'cities') {
      return null;
    }

    final rawId = widget.item.raw['departmentId'];
    if (rawId == null) {
      return null;
    }

    final departmentId = rawId is int ? rawId : int.tryParse('$rawId');
    if (departmentId == null) {
      return null;
    }

    return _apiService.fetchDepartmentNameById(departmentId);
  }

  Future<String?> _loadTouristicCityName() async {
    if (widget.endpoint.id != 'touristic-attractions') {
      return null;
    }

    final cityValue = widget.item.raw['city'];
    if (cityValue is Map<String, dynamic>) {
      final nestedName = cityValue['name'];
      if (nestedName is String && nestedName.trim().isNotEmpty) {
        return nestedName;
      }
    }

    final rawId = widget.item.raw['cityId'];
    if (rawId == null) {
      return null;
    }

    final cityId = rawId is int ? rawId : int.tryParse('$rawId');
    if (cityId == null) {
      return null;
    }

    return _apiService.fetchCityNameById(cityId);
  }
}