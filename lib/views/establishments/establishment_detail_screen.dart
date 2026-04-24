import 'package:desarrollo_movil/models/establishment_model.dart';
import 'package:desarrollo_movil/services/establishment_service.dart';
import 'package:desarrollo_movil/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EstablishmentDetailScreen extends StatefulWidget {
  const EstablishmentDetailScreen({super.key, required this.id});

  final String id;

  @override
  State<EstablishmentDetailScreen> createState() => _EstablishmentDetailScreenState();
}

class _EstablishmentDetailScreenState extends State<EstablishmentDetailScreen> {
  final EstablishmentService _service = EstablishmentService();
  late final Future<EstablishmentModel?> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchById(widget.id);
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar establecimiento'),
          content: const Text('¿Seguro que deseas eliminar este establecimiento?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    final deleted = await _service.delete(widget.id);
    if (!mounted) {
      return;
    }

    if (deleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Establecimiento eliminado')),
      );
      context.go('/establishments');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No fue posible eliminar el establecimiento')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Establecimiento')),
      drawer: const CustomDrawer(),
      body: FutureBuilder<EstablishmentModel?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('No fue posible cargar el detalle: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final establishment = snapshot.data;
          if (establishment == null) {
            return const Center(child: Text('El establecimiento no existe o no se pudo cargar.'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  FilledButton.icon(
                    onPressed: () => context.go('/establishments/${widget.id}/edit'),
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar'),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    onPressed: _delete,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Eliminar'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if ((establishment.logo ?? '').isNotEmpty)
                        SizedBox(
                          height: 130,
                          width: double.infinity,
                          child: Image.network(
                            establishment.logo!,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 72),
                          ),
                        ),
                      if ((establishment.logo ?? '').isNotEmpty)
                        const SizedBox(height: 14),
                      Text(
                        establishment.nombre ?? 'Sin nombre',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      _DetailRow(label: 'ID', value: '${establishment.id ?? 'N/A'}'),
                      _DetailRow(label: 'NIT', value: establishment.nit ?? 'N/A'),
                      _DetailRow(label: 'Dirección', value: establishment.direccion ?? 'N/A'),
                      _DetailRow(label: 'Teléfono', value: establishment.telefono ?? 'N/A'),
                      _DetailRow(label: 'Logo', value: establishment.logo ?? 'N/A'),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }
}
