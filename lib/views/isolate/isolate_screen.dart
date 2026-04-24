import 'dart:async';

import 'package:desarrollo_movil/services/isolate_service.dart';
import 'package:desarrollo_movil/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class IsolateScreen extends StatefulWidget {
  const IsolateScreen({super.key});

  @override
  State<IsolateScreen> createState() => _IsolateScreenState();
}

class _IsolateScreenState extends State<IsolateScreen> {
  final IsolateService _isolateService = IsolateService();

  bool _isLoading = false;
  String _estado = 'Presiona el boton para ejecutar la tarea pesada.';
  String _resultado = '-';
  Color _colorEstado = const Color.fromARGB(255, 70, 70, 70);
  int _latidoUI = 0;
  int _toquesUsuario = 0;
  Timer? _timerUI;

  void _iniciarIndicadorUI() {
    _timerUI?.cancel();
    _latidoUI = 0;
    _timerUI = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!mounted) return;
      setState(() {
        _latidoUI++;
      });
    });
  }

  void _detenerIndicadorUI() {
    _timerUI?.cancel();
    _timerUI = null;
  }

  Future<void> _ejecutarTareaPesada() async {
    setState(() {
      _isLoading = true;
      _estado = 'Procesando en isolate...';
      _resultado = '-';
      _colorEstado = Colors.orange;
    });
    _iniciarIndicadorUI();

    try {
      final suma = await _isolateService.ejecutarSumaGrande();

      if (!mounted) return;
      setState(() {
        _estado = 'Proceso completado';
        _resultado = '$suma';
        _colorEstado = Colors.green;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _estado = 'Error al ejecutar la tarea';
        _resultado = '-';
        _colorEstado = Colors.red;
      });
    } finally {
      _detenerIndicadorUI();
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _detenerIndicadorUI();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Isolate')),
      drawer: const CustomDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _estado,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _colorEstado,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _resultado,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _ejecutarTareaPesada,
                child: const Text('Ejecutar proceso pesado'),
              ),
              const SizedBox(height: 24),
              Text(
                _isLoading
                    ? 'UI activa (latido cada 100ms): $_latidoUI'
                    : 'UI en espera',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _toquesUsuario++;
                  });
                },
                child: Text('Probar UI (+1): $_toquesUsuario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}