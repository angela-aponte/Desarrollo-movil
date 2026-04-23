class ApiColombiaItemModel {
  const ApiColombiaItemModel({
    required this.title,
    required this.raw,
    this.id,
  });

  final int? id;
  final String title;
  final Map<String, dynamic> raw;

  factory ApiColombiaItemModel.fromJson(Map<String, dynamic> json) {
    return ApiColombiaItemModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}'),
      title: _resolveTitle(json),
      raw: Map<String, dynamic>.from(json),
    );
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>.from(raw);
    if (id != null) {
      data['id'] = id;
    }
    data['title'] = title;
    return data;
  }

  static String _resolveTitle(Map<String, dynamic> json) {
    const preferredKeys = [
      'name',
      'title',
      'description',
      'cityName',
      'department',
      'region',
      'category',
    ];

    for (final key in preferredKeys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
    }

    return 'Elemento sin nombre';
  }
}
