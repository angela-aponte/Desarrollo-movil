import 'package:desarrollo_movil/models/api_colombia_item_model.dart';
import 'package:desarrollo_movil/models/endpoint_card_model.dart';
import 'package:desarrollo_movil/services/api_colombia_service.dart';
import 'package:desarrollo_movil/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EndpointListScreen extends StatefulWidget {
  const EndpointListScreen({
    required this.endpoint,
    super.key,
  });

  final EndpointCardModel endpoint;

  @override
  State<EndpointListScreen> createState() => _EndpointListScreenState();
}

class _EndpointListScreenState extends State<EndpointListScreen> {
  late final Future<List<ApiColombiaItemModel>> _itemsFuture;
  final ApiColombiaService _apiService = ApiColombiaService();

  @override
  void initState() {
    super.initState();
    _itemsFuture = _apiService.fetchEndpointItems(widget.endpoint.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Listado: ${widget.endpoint.title}')),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.endpoint.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Endpoint: ${widget.endpoint.path}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.home),
              label: const Text('Volver al Home'),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: FutureBuilder<List<ApiColombiaItemModel>>(
                future: _itemsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error al consultar la API:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final items = snapshot.data ?? const [];
                  if (items.isEmpty) {
                    return const Center(
                      child: Text('No se encontraron resultados.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text('${index + 1}'),
                          ),
                          title: Text(item.title),
                          subtitle: Text(
                            item.id != null ? 'ID: ${item.id}' : 'Sin ID',
                          ),
                          onTap: () {
                            context.push(
                              '/endpoint/${widget.endpoint.id}/detail',
                              extra: item,
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
