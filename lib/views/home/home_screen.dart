import 'package:desarrollo_movil/models/accident_record_model.dart';
import 'package:desarrollo_movil/models/establishment_model.dart';
import 'package:desarrollo_movil/services/accident_service.dart';
import 'package:desarrollo_movil/services/establishment_service.dart';
import 'package:desarrollo_movil/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AccidentService _accidentService = AccidentService();
  final EstablishmentService _establishmentService = EstablishmentService();
  late final Future<_DashboardData> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadDashboardData();
  }

  Future<_DashboardData> _loadDashboardData() async {
    final results = await Future.wait<dynamic>([
      _loadAccidentsSafely(),
      _loadEstablishmentsSafely(),
    ]);

    final accidentsResult = results[0] as _DataResult<AccidentRecordModel>;
    final establishmentsResult =
        results[1] as _DataResult<EstablishmentModel>;

    final warnings = <String>[
      ...accidentsResult.warnings,
      ...establishmentsResult.warnings,
    ];

    return _DashboardData(
      accidents: accidentsResult.items,
      establishments: establishmentsResult.items,
      warnings: warnings,
    );
  }

  Future<_DataResult<AccidentRecordModel>> _loadAccidentsSafely() async {
    try {
      final data = await _accidentService.fetchAccidents(limit: 100000);
      return _DataResult(items: data, warnings: const []);
    } catch (error) {
      return _DataResult(
        items: const [],
        warnings: [
          'No fue posible cargar accidentes: $error',
        ],
      );
    }
  }

  Future<_DataResult<EstablishmentModel>> _loadEstablishmentsSafely() async {
    try {
      final data = await _establishmentService.fetchAll();
      return _DataResult(items: data, warnings: const []);
    } catch (error) {
      return _DataResult(
        items: const [],
        warnings: [
          'No fue posible cargar establecimientos: $error',
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Principal')),
      drawer: const CustomDrawer(),
      body: FutureBuilder<_DashboardData>(
        future: _future,
        builder: (context, snapshot) {
          final loading = snapshot.connectionState == ConnectionState.waiting;
          final data = snapshot.data ?? const _DashboardData.empty();

          return Skeletonizer(
            enabled: loading,
            child: _DashboardContent(data: data),
          );
        },
      ),
    );
  }
}

class _DashboardData {
  const _DashboardData({
    required this.accidents,
    required this.establishments,
    required this.warnings,
  });

  const _DashboardData.empty()
      : accidents = const [],
        establishments = const [],
        warnings = const [];

  final List<AccidentRecordModel> accidents;
  final List<EstablishmentModel> establishments;
  final List<String> warnings;
}

class _DataResult<T> {
  const _DataResult({
    required this.items,
    required this.warnings,
  });

  final List<T> items;
  final List<String> warnings;
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.data});

  final _DashboardData data;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (data.warnings.isNotEmpty) ...[
          Card(
            color: const Color(0xFFFFF4E5),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Algunas fuentes no cargaron',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  ...data.warnings.map((warning) => Text('• $warning')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        Text(
          'Resumen general',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Acceso rápido a las dos APIs integradas y su información consolidada.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.18,
          children: [
            _SummaryCard(
              title: 'Accidentes cargados',
              value: '${data.accidents.length}',
              icon: Icons.car_crash,
              accent: const Color(0xFFB23A48),
              onTap: () => context.go('/accidents'),
            ),
            _SummaryCard(
              title: 'Establecimientos',
              value: '${data.establishments.length}',
              icon: Icons.storefront,
              accent: const Color(0xFF1D6F42),
              onTap: () => context.go('/establishments'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _AccessCard(
          title: 'Estadísticas de Accidentes',
          description:
              'Consulta de datos abiertos con carga masiva usando \$limit=100000 y procesamiento en segundo plano.',
          icon: Icons.bar_chart,
          onTap: () => context.go('/accidents'),
        ),
        const SizedBox(height: 12),
        _AccessCard(
          title: 'Gestión de Establecimientos',
          description:
              'Listado, detalle y operaciones de establecimiento con soporte para multipart y method spoofing.',
          icon: Icons.assignment,
          onTap: () => context.go('/establishments'),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [accent.withValues(alpha: 0.95), accent.withValues(alpha: 0.75)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white, size: 30),
              const SizedBox(height: 8),
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccessCard extends StatelessWidget {
  const _AccessCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                child: Icon(icon),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(description),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}