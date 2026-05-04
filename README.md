# Desarrollo Movil - API Colombia (Flutter)

Aplicacion Flutter con navegacion usando go_router para consumir API Colombia, mostrar un dashboard de endpoints, listar registros y visualizar detalle (maestro-detalle) con campos personalizados.

## 1. API usada y endpoints seleccionados

- API base: https://api-colombia.com/
- Endpoint base publico: https://api-colombia.com/api/v1/

Endpoints implementados en la app:

1. Departamentos: `/api/v1/Department`
2. Ciudades: `/api/v1/City`
3. Regiones: `/api/v1/Region`
4. Sitios turisticos: `/api/v1/TouristicAttraction`

La configuracion de la URL base se obtiene desde `.env` y se centraliza en `lib/config/app_config.dart`.

## 2. Arquitectura y estructura del proyecto

Estructura principal:

```text
lib/
	config/          // configuracion general (AppConfig y uso de .env)
	models/          // modelos con fromJson y toJson
	routes/          // configuracion de go_router
	services/        // llamadas HTTP y transformacion de datos
	themes/          // tema global
	views/           // pantallas (Dashboard, Listado, Detalle)
	widgets/         // componentes reutilizables
	main.dart
```

Responsabilidades:

- `models/`: definicion de entidades (`ApiColombiaItemModel`, `EndpointCardModel`, `EndpointDetailFieldModel`)
- `services/`: consumo API, resolucion de nombres relacionados (por ejemplo ciudad capital y departamento)
- `routes/`: rutas tipicas y rutas dinamicas con parametros
- `views/`: flujo maestro-detalle (home -> listado -> detalle)
- `widgets/`: drawer reutilizable

## 3. Capturas (Dashboard, Listado, Detalle y estados)

Incluye en esta seccion las capturas de evidencias de ejecucion:

1. Dashboard de endpoints
2. Listado con datos
3. Detalle de un registro
4. Estado de carga
5. Estado de error
6. Estado sin resultados

Plantilla sugerida para documentarlas:

```md
### Dashboard
![Dashboard](assets/screenshots/dashboard.png)

### Listado
![Listado](assets/screenshots/listado.png)

### Detalle
![Detalle](assets/screenshots/detalle.png)

### Estado de carga
![Loading](assets/screenshots/estado_loading.png)

### Estado de error
![Error](assets/screenshots/estado_error.png)

### Estado vacio
![Vacio](assets/screenshots/estado_vacio.png)
```

## 4. Rutas implementadas con go_router y parametros

Rutas base del modulo API:

1. Home: `/`
2. Listado por endpoint: `/endpoint/:endpointId`
3. Detalle por endpoint: `/endpoint/:endpointId/detail`

Parametros enviados:

- `endpointId` se envia como parametro de ruta en listado y detalle.
- En detalle se envia el registro seleccionado por `extra` (`ApiColombiaItemModel`) desde la pantalla de listado.

Ejemplo de navegacion:

```dart
context.go('/endpoint/${card.id}');

context.push(
	'/endpoint/${widget.endpoint.id}/detail',
	extra: item,
);
```

## 5. Manejo de estados

En `EndpointListScreen` se usa `FutureBuilder` para representar estados de UI:

1. Cargando: `ConnectionState.waiting` -> `CircularProgressIndicator`
2. Error: `snapshot.hasError` -> mensaje de error
3. Vacio: lista vacia -> "No se encontraron resultados"
4. Exito: `ListView.builder` con registros

En `EndpointDetailScreen`, para campos relacionales, se usa `FutureBuilder` adicional para resolver nombres (por ejemplo `cityCapitalId` -> nombre de ciudad).

## 6. Ejemplo de respuesta JSON

Ejemplo simplificado de un registro del endpoint de Departamentos:

```json
{
	"id": 3,
	"name": "Arauca",
	"description": "Departamento de la region Orinoquia",
	"cityCapitalId": 143,
	"municipalities": 7,
	"surface": 23818,
	"population": 304978,
	"phonePrefix": "7"
}
```

Endpoint base de referencia:

- https://api-colombia.com/api/v1/

## 7. Ejecucion

```bash
flutter pub get
flutter run
```