import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:desarrollo_movil/models/endpoint_card_model.dart';
import 'package:desarrollo_movil/services/api_colombia_service.dart';
import '../../widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final ApiColombiaService _apiService = ApiColombiaService();


  @override
  Widget build(BuildContext context) {
    final cards = _apiService.getSelectedEndpoints();

    return Scaffold(
      appBar: AppBar(title: const Text('API Colombia')),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Endpoints disponibles',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Selecciona una card para consultar la API y ver resultados.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: cards.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.15,
                ),
                itemBuilder: (context, index) {
                  final card = cards[index];
                  return _HomeCard(
                    card: card,
                    onTap: () => context.go('/endpoint/${card.id}'),
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

class _HomeCard extends StatelessWidget {
  const _HomeCard({
    required this.card,
    required this.onTap,
  });

  final EndpointCardModel card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_resolveIcon(card.iconName), size: 32),
              const SizedBox(height: 10),
              Text(
                card.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  card.description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 6),
              const Text('Ver listado'),
            ],
          ),
        ),
      ),
    );
  }

  IconData _resolveIcon(String iconName) {
    switch (iconName) {
      case 'map':
        return Icons.map;
      case 'location_city':
        return Icons.location_city;
      case 'public':
        return Icons.public;
      case 'place':
        return Icons.place;
      default:
        return Icons.link;
    }
  }
}
