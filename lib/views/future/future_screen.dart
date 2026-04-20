import 'package:desarrollo_movil/services/future_service.dart';
import 'package:desarrollo_movil/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';


class FutureScreen extends StatefulWidget {
  const FutureScreen({super.key});

  @override
  State<FutureScreen> createState() => _FutureScreenState();
}

class _FutureScreenState extends State<FutureScreen> {
  bool _isLoading = false;
  String _statusMessage = 'Presiona el boton para iniciar la consulta.';
  Color _statusColor = const Color.fromARGB(255, 70, 70, 70);

  Future<void> _loadOrder() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Cargando...';
      _statusColor = Colors.orange;
    });

    try {
      await mensajePedido();

      if (!mounted) return;
      setState(() {
        _statusMessage = 'Exito';
        _statusColor = Colors.green;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _statusMessage = 'Error';
        _statusColor = Colors.red;
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Future / Async / Await')),
      drawer: const CustomDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _statusMessage,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _statusColor,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _loadOrder,
                child: const Text('Simular consulta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}