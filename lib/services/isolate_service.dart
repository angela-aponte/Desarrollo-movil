import 'dart:async';
import 'dart:isolate';

class IsolateService {
  Future<int> ejecutarSumaGrande({int limite = 200000000}) async {
    final receivePort = ReceivePort();
    final errorPort = ReceivePort();
    final completer = Completer<int>();

    final isolate = await Isolate.spawn(
      _entradaSumaGrande,
      {
        'sendPort': receivePort.sendPort,
        'limite': limite,
      },
      onError: errorPort.sendPort,
      errorsAreFatal: true,
    );

    late final StreamSubscription resultadoSub;
    late final StreamSubscription errorSub;

    resultadoSub = receivePort.listen((message) {
      if (message is int && !completer.isCompleted) {
        completer.complete(message);
      }
    });

    errorSub = errorPort.listen((_) {
      if (!completer.isCompleted) {
        completer.completeError('Error al ejecutar el isolate');
      }
    });

    try {
      return await completer.future;
    } finally {
      await resultadoSub.cancel();
      await errorSub.cancel();
      receivePort.close();
      errorPort.close();
      isolate.kill(priority: Isolate.immediate);
    }
  }
}

void _entradaSumaGrande(Map<String, Object> datos) {
  final sendPort = datos['sendPort'] as SendPort;
  final limite = datos['limite'] as int;

  var suma = 0;
  for (var i = 1; i <= limite; i++) {
    suma += i;
  }

  sendPort.send(suma);
}