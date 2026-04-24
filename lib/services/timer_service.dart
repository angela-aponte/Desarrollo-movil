import 'dart:async';

class TimerService {
  TimerService({required this.onTick});

  final void Function(int segundos) onTick;

  Timer? _timer;
  int _segundos = 0;
  bool _estaCorriendo = false;

  bool get estaCorriendo => _estaCorriendo;

  String get tiempoFormateado {
    final minutos = (_segundos ~/ 60).toString().padLeft(2, '0');
    final segundos = (_segundos % 60).toString().padLeft(2, '0');
    return '$minutos:$segundos';
  }

  void iniciar() {
    if (_estaCorriendo) return;
    _iniciarTimer();
  }

  void pausar() {
    _timer?.cancel();
    _timer = null;
    _estaCorriendo = false;
  }

  void reanudar() {
    if (_estaCorriendo) return;
    _iniciarTimer();
  }

  void reiniciar() {
    _timer?.cancel();
    _timer = null;
    _segundos = 0;
    _estaCorriendo = false;
    onTick(_segundos);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
    _estaCorriendo = false;
  }

  void _iniciarTimer() {
    _estaCorriendo = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _segundos++;
      onTick(_segundos);
    });
  }
}