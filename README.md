# Desarrollo Movil - Distribucion de APK

Este proyecto Flutter incluye flujo de construccion y distribucion interna para pruebas con testers.

## Flujo general

Generar APK -> App Distribution -> Testers -> Instalacion -> Actualizacion

Breve explicacion del flujo:

1. Generar APK: se compila una build firmada para distribucion.
2. App Distribution: se sube el APK a Firebase App Distribution.
3. Testers: se asignan testers o grupos para recibir la release.
4. Instalacion: cada tester instala la app desde el enlace de Firebase.
5. Actualizacion: nuevas versiones se publican sobre el mismo flujo.

## Publicacion

Pasos resumidos:

1. Actualizar version en `pubspec.yaml` (ejemplo: `version: 1.1.0+2`).
2. Generar APK:

```bash
flutter clean
flutter pub get
flutter build apk --release
```

3. Subir APK a Firebase App Distribution (consola web o CLI).
4. Agregar release notes y seleccionar testers/grupos.
5. Publicar y validar instalacion desde correo/enlace de distribucion.

Como replicar el proceso en el equipo:

1. Definir responsable de versionado por sprint/release.
2. Usar misma convencion de version y release notes.
3. Mantener lista unica de testers/grupos en Firebase.
4. Verificar que todos usen mismo `applicationId` y proyecto Firebase.
5. Documentar en PR: version, changelog y enlace de distribucion.

Ejemplo CLI (opcional) para equipos con Firebase CLI configurado:

```bash
firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk \
  --app <FIREBASE_APP_ID> \
  --groups "qa-testers" \
  --release-notes "Fix rutas y estabilidad de inicio"
```

## Versionado

Formato usado en Flutter:

- `version: MAJOR.MINOR.PATCH+BUILD`
- Ejemplo: `version: 1.0.1+2`

Guia recomendada:

1. MAJOR: cambios incompatibles.
2. MINOR: nuevas funcionalidades compatibles.
3. PATCH: correcciones sin ruptura.
4. BUILD: numero interno de compilacion/distribucion.

## Formato de Release Notes

Plantilla corta usada en el proyecto:

```md
Release Notes - v1.1.0+2

- Fix: correccion de errores de inicializacion en `main.dart`.
- Fix: limpieza y orden de imports/rutas en `app_router.dart`.
- Improve: estabilidad general del flujo de navegacion.
- Build: APK de release generado y distribuido a testers.
```

Sugerencia:

- Mantener 3-6 bullets maximos.
- Separar en categorias: `Fix`, `Improve`, `Feature`, `Build`.
- Evitar texto largo; enfocar en impacto para tester/usuario.

## Capturas o GIFs del panel

Incluye capturas breves del panel de App Distribution para evidencias:

1. Pantalla de releases.
2. Formulario de carga de APK/AAB.
3. Seleccion de testers o grupos.
4. Release notes publicadas.

Plantilla sugerida (agrega tus archivos en `assets/screenshots/`):

```md
### Panel - Releases
![Panel Releases](assets/screenshots/app_distribution_releases.png)

### Panel - Carga de build
![Upload Build](assets/screenshots/app_distribution_upload.gif)

### Panel - Testers
![Testers](assets/screenshots/app_distribution_testers.png)

### Panel - Release Notes
![Release Notes](assets/screenshots/app_distribution_release_notes.png)
```

## Ejecucion local

```bash
flutter pub get
flutter run
```