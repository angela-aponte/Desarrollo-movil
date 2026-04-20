import 'package:desarrollo_movil/services/timer_service.dart';
import 'package:desarrollo_movil/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late final TimerService _timerService;
  bool _haIniciado = false;
  int _segundos = 0;

  @override
  void initState() {
    super.initState();
    _timerService = TimerService(onTick: (segundos) {
      if (!mounted) return;
      setState(() {
        _segundos = segundos;
      });
    });
  }

  @override
  void dispose() {
    _timerService.dispose();
    super.dispose();
  }

  String get _tiempoFormateado {
    final minutos = (_segundos ~/ 60).toString().padLeft(2, '0');
    final segundos = (_segundos % 60).toString().padLeft(2, '0');
    return '$minutos:$segundos';
  }

  void _iniciar() {
    _timerService.iniciar();
    setState(() {
      _haIniciado = true;
    });
  }

  void _pausar() {
    _timerService.pausar();
    setState(() {});
  }

  void _reanudar() {
    _timerService.reanudar();
    setState(() {
      _haIniciado = true;
    });
  }

  void _reiniciar() {
    _timerService.reiniciar();
    setState(() {
      _haIniciado = false;
      _segundos = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final estaCorriendo = _timerService.estaCorriendo;

    return Scaffold(
      appBar: AppBar(title: const Text('Timer')),
      drawer: const CustomDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _tiempoFormateado,
                style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 28),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: !estaCorriendo && !_haIniciado ? _iniciar : null,
                    child: const Text('Iniciar'),
                  ),
                  ElevatedButton(
                    onPressed: estaCorriendo ? _pausar : null,
                    child: const Text('Pausar'),
                  ),
                  ElevatedButton(
                    onPressed: !estaCorriendo && _haIniciado ? _reanudar : null,
                    child: const Text('Reanudar'),
                  ),
                  ElevatedButton(
                    onPressed: _haIniciado || estaCorriendo ? _reiniciar : null,
                    child: const Text('Reiniciar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}