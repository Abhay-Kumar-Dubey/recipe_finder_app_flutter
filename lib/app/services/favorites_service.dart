import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_finder_app/app/data/models/favorite_recipe_model.dart';

class FavoritesService {
  static const String _boxName = 'favorites';
  static Box<FavoriteRecipeModel>? _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(FavoriteRecipeModelAdapter());
    _box = await Hive.openBox<FavoriteRecipeModel>(_boxName);
  }

  static Box<FavoriteRecipeModel> get box {
    if (_box == null) {
      throw Exception('FavoritesService not initialized. Call init() first.');
    }
    return _box!;
  }

  // Add a recipe to favorites
  static Future<void> addToFavorites(FavoriteRecipeModel recipe) async {
    await box.put(recipe.id, recipe);
  }

  // Remove a recipe from favorites
  static Future<void> removeFromFavorites(String recipeId) async {
    await box.delete(recipeId);
  }

  // Check if a recipe is in favorites
  static bool isFavorite(String recipeId) {
    return box.containsKey(recipeId);
  }

  // Get all favorite recipes
  static List<FavoriteRecipeModel> getAllFavorites() {
    return box.values.toList()
      ..sort((a, b) => b.addedAt.compareTo(a.addedAt)); // Sort by newest first
  }

  // Get favorite recipe by ID
  static FavoriteRecipeModel? getFavorite(String recipeId) {
    return box.get(recipeId);
  }

  // Clear all favorites
  static Future<void> clearAllFavorites() async {
    await box.clear();
  }

  // Get favorites count
  static int getFavoritesCount() {
    return box.length;
  }
}