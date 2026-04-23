import 'package:desarrollo_movil/models/endpoint_card_model.dart';
import 'package:flutter/material.dart';

class EndpointListScreen extends StatelessWidget {
  const EndpointListScreen({
    required this.endpoint,
    super.key,
  });

  final EndpointCardModel endpoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Listado: ${endpoint.title}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              endpoint.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Endpoint: ${endpoint.path}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Text(
                  'Vista de listado pendiente de implementacion',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
