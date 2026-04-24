import 'package:desarrollo_movil/models/accident_record_model.dart';
import 'package:desarrollo_movil/services/accident_service.dart';
import 'package:desarrollo_movil/widgets/custom_drawer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AccidentStatisticsScreen extends StatefulWidget {
  const AccidentStatisticsScreen({super.key});

  @override
  State<AccidentStatisticsScreen> createState() => _AccidentStatisticsScreenState();
}

class _AccidentStatisticsScreenState extends State<AccidentStatisticsScreen> {
  final AccidentService _service = AccidentService();
  late final Future<_AccidentDashboardData> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadData();
  }

  Future<_AccidentDashboardData> _loadData() async {
    final accidents = await _service.fetchAccidents(limit: 100000);
    final analytics = await compute(
      _buildAccidentAnalytics,
      accidents.map((item) => item.toJson()).toList(),
    );
    return _AccidentDashboardData(
      accidents: accidents,
      analytics: analytics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estadísticas de Accidentes')),
      drawer: const CustomDrawer(),
      body: FutureBuilder<_AccidentDashboardData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _StateMessage(
              icon: Icons.error_outline,
              title: 'No fue posible cargar los accidentes',
              message: '${snapshot.error}',
            );
          }

          final loading = snapshot.connectionState == ConnectionState.waiting;
          final data = snapshot.data ?? _AccidentDashboardData.empty;

          return Skeletonizer(
            enabled: loading,
            child: _AccidentContent(data: data),
          );
        },
      ),
    );
  }
}

class _AccidentDashboardData {
  const _AccidentDashboardData({
    required this.accidents,
    required this.analytics,
  });

  static const empty = _AccidentDashboardData(
    accidents: [],
    analytics: _AccidentAnalytics.empty,
  );

  final List<AccidentRecordModel> accidents;
  final _AccidentAnalytics analytics;
}

class _AccidentAnalytics {
  const _AccidentAnalytics({
    required this.classDistribution,
    required this.severityDistribution,
    required this.topNeighborhoods,
    required this.weekdayDistribution,
  });

  static const empty = _AccidentAnalytics(
    classDistribution: {
      'Choque': 0,
      'Atropello': 0,
      'Volcamiento': 0,
      'Otros': 0,
    },
    severityDistribution: {
      'Con muertos': 0,
      'Con heridos': 0,
      'Solo daños': 0,
    },
    topNeighborhoods: {},
    weekdayDistribution: {
      'Lunes': 0,
      'Martes': 0,
      'Miércoles': 0,
      'Jueves': 0,
      'Viernes': 0,
      'Sábado': 0,
      'Domingo': 0,
    },
  );

  final Map<String, int> classDistribution;
  final Map<String, int> severityDistribution;
  final Map<String, int> topNeighborhoods;
  final Map<String, int> weekdayDistribution;
}

_AccidentAnalytics _buildAccidentAnalytics(List<Map<String, dynamic>> rows) {
  final classDistribution = <String, int>{
    'Choque': 0,
    'Atropello': 0,
    'Volcamiento': 0,
    'Otros': 0,
  };

  final severityDistribution = <String, int>{
    'Con muertos': 0,
    'Con heridos': 0,
    'Solo daños': 0,
  };

  final neighborhoodCounts = <String, int>{};
  final weekdayDistribution = <String, int>{
    'Lunes': 0,
    'Martes': 0,
    'Miércoles': 0,
    'Jueves': 0,
    'Viernes': 0,
    'Sábado': 0,
    'Domingo': 0,
  };

  for (final row in rows) {
    final accidentClass = _normalizeAccidentClass(row['clase_de_accidente']?.toString());
    classDistribution[accidentClass] = (classDistribution[accidentClass] ?? 0) + 1;

    final severity = _normalizeSeverity(row['gravedad_del_accidente']?.toString());
    severityDistribution[severity] = (severityDistribution[severity] ?? 0) + 1;

    final neighborhood = row['barrio_hecho']?.toString().trim();
    if (neighborhood != null && neighborhood.isNotEmpty) {
      neighborhoodCounts[neighborhood] = (neighborhoodCounts[neighborhood] ?? 0) + 1;
    }

    final day = _normalizeWeekday(row['dia']?.toString());
    if (day != null) {
      weekdayDistribution[day] = (weekdayDistribution[day] ?? 0) + 1;
    }
  }

  final topNeighborhoodEntries = neighborhoodCounts.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  final topNeighborhoods = <String, int>{
    for (final item in topNeighborhoodEntries.take(5)) item.key: item.value,
  };

  return _AccidentAnalytics(
    classDistribution: classDistribution,
    severityDistribution: severityDistribution,
    topNeighborhoods: topNeighborhoods,
    weekdayDistribution: weekdayDistribution,
  );
}

String _normalizeAccidentClass(String? raw) {
  final value = (raw ?? '').toLowerCase();
  if (value.contains('choque')) {
    return 'Choque';
  }
  if (value.contains('atrop')) {
    return 'Atropello';
  }
  if (value.contains('volcam')) {
    return 'Volcamiento';
  }
  return 'Otros';
}

String _normalizeSeverity(String? raw) {
  final value = (raw ?? '').toLowerCase();
  if (value.contains('muert') || value.contains('fatal')) {
    return 'Con muertos';
  }
  if (value.contains('herid')) {
    return 'Con heridos';
  }
  return 'Solo daños';
}

String? _normalizeWeekday(String? raw) {
  if (raw == null) {
    return null;
  }

  const mapping = <String, String>{
    'lunes': 'Lunes',
    'martes': 'Martes',
    'miercoles': 'Miércoles',
    'miércoles': 'Miércoles',
    'jueves': 'Jueves',
    'viernes': 'Viernes',
    'sabado': 'Sábado',
    'sábado': 'Sábado',
    'domingo': 'Domingo',
  };

  final value = raw.trim().toLowerCase();
  return mapping[value];
}

class _AccidentContent extends StatelessWidget {
  const _AccidentContent({required this.data});

  final _AccidentDashboardData data;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Total de accidentes cargados: ${data.accidents.length}',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        _ChartCard(
          title: 'Distribución por clase de accidente',
          child: _PieChartWidget(data: data.analytics.classDistribution),
        ),
        _ChartCard(
          title: 'Distribución por gravedad',
          child: _PieChartWidget(data: data.analytics.severityDistribution),
        ),
        _ChartCard(
          title: 'Top 5 barrios con más accidentes',
          child: _BarChartWidget(data: data.analytics.topNeighborhoods),
        ),
        _ChartCard(
          title: 'Distribución por día de la semana',
          child: _BarChartWidget(data: data.analytics.weekdayDistribution),
        ),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            SizedBox(height: 240, child: child),
          ],
        ),
      ),
    );
  }
}

class _PieChartWidget extends StatelessWidget {
  const _PieChartWidget({required this.data});

  final Map<String, int> data;

  @override
  Widget build(BuildContext context) {
    final total = data.values.fold<int>(0, (sum, item) => sum + item);
    if (total == 0) {
      return const Center(child: Text('Sin datos para visualizar'));
    }

    final colors = <Color>[
      const Color(0xFFB23A48),
      const Color(0xFF3A86FF),
      const Color(0xFFF4A261),
      const Color(0xFF2A9D8F),
      const Color(0xFF6D597A),
      const Color(0xFF8AB17D),
      const Color(0xFFE76F51),
    ];

    final entries = data.entries.toList();

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: List.generate(entries.length, (index) {
                final item = entries[index];
                final color = colors[index % colors.length];
                final percentage = (item.value / total) * 100;

                return PieChartSectionData(
                  value: item.value.toDouble(),
                  color: color,
                  radius: 58,
                  title: '${percentage.toStringAsFixed(1)}%',
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: List.generate(entries.length, (index) {
            final item = entries[index];
            final color = colors[index % colors.length];
            return Chip(
              avatar: CircleAvatar(backgroundColor: color, radius: 7),
              label: Text('${item.key}: ${item.value}'),
            );
          }),
        ),
      ],
    );
  }
}

class _BarChartWidget extends StatelessWidget {
  const _BarChartWidget({required this.data});

  final Map<String, int> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty || data.values.every((value) => value == 0)) {
      return const Center(child: Text('Sin datos para visualizar'));
    }

    final entries = data.entries.toList();
    final maxY = entries.map((item) => item.value).reduce((a, b) => a > b ? a : b).toDouble();

    return BarChart(
      BarChartData(
        maxY: maxY == 0 ? 1 : maxY * 1.2,
        barTouchData: BarTouchData(enabled: false),
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 32),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 46,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= entries.length) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Transform.rotate(
                    angle: -0.4,
                    child: Text(
                      entries[index].key,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: List.generate(entries.length, (index) {
          final item = entries[index];
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: item.value.toDouble(),
                width: 16,
                borderRadius: BorderRadius.circular(4),
                color: const Color(0xFF1D6F42),
              ),
            ],
          );
        }),
      ),
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
