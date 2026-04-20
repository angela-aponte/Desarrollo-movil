import 'package:flutter/material.dart';
import '../../widgets/custom_drawer.dart';

class CicloVidaScreen extends StatefulWidget {
  const CicloVidaScreen({super.key});

  @override
  State<CicloVidaScreen> createState() => _CicloVidaScreenState();
}

class _CicloVidaScreenState extends State<CicloVidaScreen> {
  @override
  void initState() {
    super.initState();
    print('initState - Se inicializa el widget');
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose - Se libera el widget');
  }

  @override
  Widget build(BuildContext context) {
    print('build - Se construye la UI');
    return Scaffold(
      appBar: AppBar(title: const Text('Ciclo de Vida')),
      drawer: const CustomDrawer(),
      body: const Center(
        child: Text(
          'Pantalla de Ciclo de Vida\nRevisa la consola para ver los eventos',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
