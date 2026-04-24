class EstablishmentModel {
  const EstablishmentModel({
    required this.raw,
    this.id,
    this.nombre,
    this.nit,
    this.direccion,
    this.telefono,
    this.logo,
  });

  final int? id;
  final String? nombre;
  final String? nit;
  final String? direccion;
  final String? telefono;
  final String? logo;
  final Map<String, dynamic> raw;

  factory EstablishmentModel.fromJson(Map<String, dynamic> json) {
    return EstablishmentModel(
      id: _readInt(json['id']),
      nombre: _readText(json['nombre']),
      nit: _readText(json['nit']),
      direccion: _readText(json['direccion']),
      telefono: _readText(json['telefono']),
      logo: _readText(json['logo']),
      raw: Map<String, dynamic>.from(json),
    );
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>.from(raw);
    if (id != null) {
      data['id'] = id;
    }
    data['nombre'] = nombre;
    data['nit'] = nit;
    data['direccion'] = direccion;
    data['telefono'] = telefono;
    data['logo'] = logo;
    return data;
  }

  static int? _readInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    return int.tryParse(value.toString());
  }

  static String? _readText(dynamic value) {
    if (value == null) {
      return null;
    }
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }
}
