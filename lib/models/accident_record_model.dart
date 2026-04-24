class AccidentRecordModel {
  const AccidentRecordModel({
    required this.raw,
    this.claseDeAccidente,
    this.gravedadDelAccidente,
    this.barrioHecho,
    this.dia,
    this.hora,
    this.area,
    this.claseDeVehiculo,
  });

  final String? claseDeAccidente;
  final String? gravedadDelAccidente;
  final String? barrioHecho;
  final String? dia;
  final String? hora;
  final String? area;
  final String? claseDeVehiculo;
  final Map<String, dynamic> raw;

  factory AccidentRecordModel.fromJson(Map<String, dynamic> json) {
    return AccidentRecordModel(
      claseDeAccidente: _readText(json['clase_de_accidente']),
      gravedadDelAccidente: _readText(json['gravedad_del_accidente']),
      barrioHecho: _readText(json['barrio_hecho']),
      dia: _readText(json['dia']),
      hora: _readText(json['hora']),
      area: _readText(json['area']),
      claseDeVehiculo: _readText(json['clase_de_vehiculo']),
      raw: Map<String, dynamic>.from(json),
    );
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>.from(raw);
    data['clase_de_accidente'] = claseDeAccidente;
    data['gravedad_del_accidente'] = gravedadDelAccidente;
    data['barrio_hecho'] = barrioHecho;
    data['dia'] = dia;
    data['hora'] = hora;
    data['area'] = area;
    data['clase_de_vehiculo'] = claseDeVehiculo;
    return data;
  }

  static String? _readText(dynamic value) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }
}
