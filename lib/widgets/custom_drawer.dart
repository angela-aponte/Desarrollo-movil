import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary, // Usa el color primario del tema
            ),
            child: const Text(
              'Menú',
              style: TextStyle(
                color: Colors
                    .white, // Texto blanco para contrastar con el color primario
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              context.go('/'); // Navega a la ruta principal
              Navigator.pop(context); // Cierra el drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.car_crash),
            title: const Text('Estadísticas de Accidentes'),
            onTap: () {
              context.go('/accidents');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.storefront),
            title: const Text('Gestión de Establecimientos'),
            onTap: () {
              context.go('/establishments');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
