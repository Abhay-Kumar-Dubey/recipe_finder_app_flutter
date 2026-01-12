class RecipeDetailModel {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnailUrl;
  final String? tags;
  final String? youtubeUrl;
  final List<Ingredient> ingredients;

  RecipeDetailModel({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnailUrl,
    this.tags,
    this.youtubeUrl,
    required this.ingredients,
  });

  factory RecipeDetailModel.fromJson(Map<String, dynamic> json) {
    List<Ingredient> ingredients = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ingredients.add(
          Ingredient(
            name: ingredient.toString().trim(),
            measure: measure?.toString().trim() ?? '',
          ),
        );
      }
    }

    return RecipeDetailModel(
      id: json['idMeal'],
      name: json['strMeal'],
      category: json['strCategory'],
      area: json['strArea'],
      instructions: json['strInstructions'],
      thumbnailUrl: json['strMealThumb'],
      tags: json['strTags'],
      youtubeUrl: json['strYoutube'],
      ingredients: ingredients,
    );
  }
}

class Ingredient {
  final String name;
  final String measure;

  Ingredient({required this.name, required this.measure});
}
