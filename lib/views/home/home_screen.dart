import 'package:flutter/material.dart';
import '../../widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<_HomeCardData> _cards = [
    _HomeCardData(
      title: 'Usuarios',
      description: 'Vista informativa para el modulo de usuarios.',
      icon: Icons.people,
    ),
    _HomeCardData(
      title: 'Productos',
      description: 'Vista informativa para el modulo de productos.',
      icon: Icons.inventory_2,
    ),
    _HomeCardData(
      title: 'Ordenes',
      description: 'Vista informativa para el modulo de ordenes.',
      icon: Icons.receipt_long,
    ),
    _HomeCardData(
      title: 'Categorias',
      description: 'Vista informativa para el modulo de categorias.',
      icon: Icons.category,
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Principal')),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Modulos disponibles',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Vista base para mostrar cards informativas.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: _cards.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.15,
                ),
                itemBuilder: (context, index) {
                  final card = _cards[index];
                  return _HomeCard(
                    card: card,
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

class _HomeCardData {
  const _HomeCardData({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}

class _HomeCard extends StatelessWidget {
  const _HomeCard({required this.card});

  final _HomeCardData card;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(card.icon, size: 32),
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
            const Text('Vista disponible'),
          ],
        ),
      ),
    );
  }
}
