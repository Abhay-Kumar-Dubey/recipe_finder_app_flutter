class HomeRecipeModel {
  final String name;
  final String thumbnailUrl;
  final String id;

  HomeRecipeModel({
    required this.name,
    required this.thumbnailUrl,
    required this.id,
  });

  factory HomeRecipeModel.fromJson(Map<String, dynamic> json) {
    return HomeRecipeModel(
      name: json['strMeal']?.toString() ?? '',
      thumbnailUrl: json['strMealThumb']?.toString() ?? '',
      id: json['idMeal']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'thumbnailUrl': thumbnailUrl, 'id': id};
  }
}
