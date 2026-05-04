class EndpointCardModel {
  const EndpointCardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.path,
  });

  final String id;
  final String title;
  final String description;
  final String iconName;
  final String path;

  factory EndpointCardModel.fromJson(Map<String, dynamic> json) {
    return EndpointCardModel(
      id: '${json['id']}',
      title: '${json['title']}',
      description: '${json['description']}',
      iconName: '${json['iconName']}',
      path: '${json['path']}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconName': iconName,
      'path': path,
    };
  }
}
