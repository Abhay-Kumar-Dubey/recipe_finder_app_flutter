class AreaListModel {
  final String name;

  AreaListModel({required this.name});

  factory AreaListModel.fromJson(Map<String, dynamic> json) {
    return AreaListModel(name: json['strArea']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}
