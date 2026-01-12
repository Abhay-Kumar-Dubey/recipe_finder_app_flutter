class CategoryListModel {
  final String name;

  CategoryListModel({required this.name});

  factory CategoryListModel.fromJson(Map<String, dynamic> json) {
    return CategoryListModel(name: json['strCategory']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}
