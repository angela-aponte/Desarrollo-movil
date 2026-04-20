Future<void> mensajePedido() async {
  print('Antes: Esperando por el pedido...');
  countSeconds(4);
  var response = await ordenUsuario();
  print('Despues: $response');
}

Future<String> ordenUsuario() {
  // Imagine that this function is more complex and slow.
  print('Durante: Consultando disponibilidad del producto...');
  return Future.delayed(const Duration(seconds: 4), () => 'Producto encontrado y listo para enviar');
}

//? Simula una función que cuenta los segundos
void countSeconds(int s) {
  for (var i = 1; i <= s; i++) {
    Future.delayed(Duration(seconds: i), () => print(i));
  }
}