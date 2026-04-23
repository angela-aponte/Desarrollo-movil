import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:desarrollo_movil/views/ciclo_vida/ciclo_vida_screen.dart';
import 'package:desarrollo_movil/views/future/future_screen.dart';
import 'package:desarrollo_movil/views/home/home_screen.dart';
import 'package:desarrollo_movil/views/isolate/isolate_screen.dart';
import 'package:desarrollo_movil/views/endpoints/endpoint_list_screen.dart';
import 'package:desarrollo_movil/views/paso_parametros/detalle_screen.dart';
import 'package:desarrollo_movil/views/paso_parametros/paso_parametros_screen.dart';
import 'package:desarrollo_movil/views/timer/timer_screen.dart';
import 'package:desarrollo_movil/services/api_colombia_service.dart';

final ApiColombiaService _apiService = ApiColombiaService();

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(), // Usa HomeView
    ),
    // Rutas para el paso de parámetros
    GoRoute(
      path: '/paso_parametros',
      builder: (context, state) => const PasoParametrosScreen(),
    ),

    // !Ruta para el detalle con parámetros
    GoRoute(
      path:
          '/detalle/:parametro/:metodo', //la ruta recibe dos parametros los " : " indican que son parametros
      builder: (context, state) {
        //*se capturan los parametros recibidos
        // declarando las variables parametro y metodo
        // es final porque no se van a modificar
        final parametro = state.pathParameters['parametro']!;
        final metodo = state.pathParameters['metodo']!;
        return DetalleScreen(parametro: parametro, metodoNavegacion: metodo);
      },
    ),
    //!Ruta para el ciclo de vida
    GoRoute(
      path: '/ciclo_vida',
      name: 'ciclo_vida',
      builder: (context, state) => const CicloVidaScreen(),
    ),
    GoRoute(
      path: '/future',
      name: 'future',
      builder: (context, state) => const FutureScreen(),
    ),
    GoRoute(
      path: '/timer',
      name: 'timer',
      builder: (context, state) => const TimerScreen(),
    ),
    GoRoute(
      path: '/isolate',
      name: 'isolate',
      builder: (context, state) => const IsolateScreen(),
    ),
    GoRoute(
      path: '/endpoint/:endpointId',
      name: 'endpoint_list',
      builder: (context, state) {
        final endpointId = state.pathParameters['endpointId']!;
        final endpoint = _apiService.findById(endpointId);

        if (endpoint == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Endpoint no encontrado')),
            body: Center(
              child: Text('No existe configuracion para: $endpointId'),
            ),
          );
        }

        return EndpointListScreen(endpoint: endpoint);
      },
    ),
  ],
);
