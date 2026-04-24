import 'package:desarrollo_movil/models/establishment_model.dart';
import 'package:desarrollo_movil/services/establishment_service.dart';
import 'package:desarrollo_movil/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EstablishmentManagementScreen extends StatefulWidget {
  const EstablishmentManagementScreen({super.key});

  @override
  State<EstablishmentManagementScreen> createState() => _EstablishmentManagementScreenState();
}

class _EstablishmentManagementScreenState extends State<EstablishmentManagementScreen> {
  final EstablishmentService _service = EstablishmentService();
  late Future<List<EstablishmentModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchAll();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _service.fetchAll();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Establecimientos')),
      drawer: const CustomDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.go('/establishments/new');
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo'),
      ),
      body: FutureBuilder<List<EstablishmentModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _StateMessage(
              icon: Icons.error_outline,
              title: 'No fue posible cargar los establecimientos',
              message: '${snapshot.error}',
            );
          }

          final loading = snapshot.connectionState == ConnectionState.waiting;
          final establishments = snapshot.data ?? const <EstablishmentModel>[];

          if (!loading && establishments.isEmpty) {
            return const _StateMessage(
              icon: Icons.inbox,
              title: 'Sin establecimientos',
              message: 'No se encontraron establecimientos registrados.',
            );
          }

          final items = loading
              ? List.generate(
                  8,
                  (_) => const EstablishmentModel(
                    raw: {},
                    nombre: 'Nombre del establecimiento',
                    nit: '900000000-0',
                    direccion: 'Dirección de ejemplo',
                    telefono: '3000000000',
                  ),
                )
              : establishments;

          return Skeletonizer(
            enabled: loading,
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        'Total de establecimientos registrados: ${establishments.length}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    );
                  }

                  final item = items[index - 1];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: _LogoAvatar(url: item.logo),
                      title: Text(item.nombre ?? 'Sin nombre'),
                      subtitle: Text(
                        'NIT: ${item.nit ?? 'N/A'}\n'
                        'Dirección: ${item.direccion ?? 'N/A'}\n'
                        'Teléfono: ${item.telefono ?? 'N/A'}',
                      ),
                      isThreeLine: true,
                      onTap: item.id == null
                          ? null
                          : () {
                              context.go('/establishments/${item.id}');
                            },
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LogoAvatar extends StatelessWidget {
  const _LogoAvatar({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return const CircleAvatar(child: Icon(Icons.store));
    }

    return CircleAvatar(
      backgroundImage: NetworkImage(url!),
      onBackgroundImageError: (error, stackTrace) {},
      child: const Icon(Icons.store),
    );
  }
}

class _StateMessage extends StatelessWidget {
  const _StateMessage({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
