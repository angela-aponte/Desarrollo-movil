class EndpointDetailFieldModel {
  const EndpointDetailFieldModel({
    required this.key,
    required this.label,
  });

  final String key;
  final String label;

  factory EndpointDetailFieldModel.fromJson(Map<String, dynamic> json) {
    return EndpointDetailFieldModel(
      key: '${json['key']}',
      label: '${json['label']}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'label': label,
    };
  }
}
