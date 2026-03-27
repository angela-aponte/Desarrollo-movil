import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taller Flutter 1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String titulo = "Hola, Flutter";

  void toggleTitulo() {
    setState(() {
      titulo = (titulo == "Hola, Flutter")
          ? "¡Título cambiado!"
          : "Hola, Flutter";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Título actualizado")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            _header(),

            _imagenes(),

            _boton(),

            _containerInfo(),

            _lista(),
          ],
        ),
      ),
    );
  }

 
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: const [
          Icon(Icons.person, size: 60),
          SizedBox(height: 10),
          Text(
            "Angela Patricia Aponte Escudero",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }


  Widget _imagenes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 120,
            height: 120,
            color: Colors.grey[300],
            child: const Icon(Icons.image, size: 60),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'assets/gato.png',
            width: 120,
            height: 120,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('Error loading image: $error');
              return Container(
                width: 120,
                height: 120,
                color: Colors.red[100],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.broken_image, size: 40, color: Colors.red),
                    const Text('Error', style: TextStyle(fontSize: 10)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Botón
  Widget _boton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: toggleTitulo,
        child: const Text("Cambiar título"),
      ),
    );
  }

  // Container
  Widget _containerInfo() {
    return Card(
      margin: const EdgeInsets.all(15),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: const Text(
          "Este es un Container dentro de una Card",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  //Lista
  Widget _lista() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const Text(
            "Lista de elementos",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          ListTile(
            leading: const Icon(Icons.pets),
            title: const Text("Mascota"),
            tileColor: Colors.teal.shade50,
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text("Favorito"),
            tileColor: Colors.teal.shade100,
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text("Destacado"),
            tileColor: Colors.teal.shade50,
          ),
        ],
      ),
    );
  }
}