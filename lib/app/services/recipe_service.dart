import 'package:recipe_finder_app/app/data/models/area_list_model.dart';
import 'package:recipe_finder_app/app/data/models/category_list_model.dart';
import 'package:recipe_finder_app/app/data/models/home_recipe_model.dart';
import 'package:recipe_finder_app/app/data/models/recipe_detail_model.dart';
import 'package:recipe_finder_app/app/services/api_service.dart';

class RecipeService {
  // Get default recipes (Indian cuisine)
  static Future<List<HomeRecipeModel>> getDefaultRecipes() async {
    try {
      final data = await ApiService.filterRecipesByArea('indian');
      return data.map((json) => HomeRecipeModel.fromJson(json)).toList();
    } catch (e) {
      throw RecipeServiceException('Failed to load default recipes: $e');
    }
  }

  // Search recipes by name
  static Future<List<HomeRecipeModel>> searchRecipes(String query) async {
    try {
      if (query.trim().isEmpty) {
        return [];
      }

      final data = await ApiService.searchRecipesByName(query);
      return data.map((json) => HomeRecipeModel.fromJson(json)).toList();
    } catch (e) {
      throw RecipeServiceException('Failed to search recipes: $e');
    }
  }

  // Get recipe details by ID
  static Future<List<RecipeDetailModel>> getRecipeDetails(String id) async {
    try {
      final data = await ApiService.getRecipeById(id);
      return data.map((json) => RecipeDetailModel.fromJson(json)).toList();
    } catch (e) {
      throw RecipeServiceException('Failed to load recipe details: $e');
    }
  }

  // Filter recipes by category
  static Future<List<HomeRecipeModel>> filterByCategory(String category) async {
    try {
      final data = await ApiService.filterRecipesByCategory(category);
      return data.map((json) => HomeRecipeModel.fromJson(json)).toList();
    } catch (e) {
      throw RecipeServiceException('Failed to filter by category: $e');
    }
  }

  // Filter recipes by area
  static Future<List<HomeRecipeModel>> filterByArea(String area) async {
    try {
      final data = await ApiService.filterRecipesByArea(area);
      return data.map((json) => HomeRecipeModel.fromJson(json)).toList();
    } catch (e) {
      throw RecipeServiceException('Failed to filter by area: $e');
    }
  }

  // Get all categories for filtering
  static Future<List<CategoryListModel>> getCategories() async {
    try {
      final data = await ApiService.getCategoryList();
      return data.map((json) => CategoryListModel.fromJson(json)).toList();
    } catch (e) {
      throw RecipeServiceException('Failed to load categories: $e');
    }
  }

  // Get all areas for filtering
  static Future<List<AreaListModel>> getAreas() async {
    try {
      final data = await ApiService.getAreaList();
      return data.map((json) => AreaListModel.fromJson(json)).toList();
    } catch (e) {
      throw RecipeServiceException('Failed to load areas: $e');
    }
  }

  // Combined filter method for category and area
  static Future<List<HomeRecipeModel>> filterRecipes({
    String? category,
    String? area,
  }) async {
    try {
      // If both filters are provided, we need to fetch both and find intersection
      if (category != null && area != null) {
        final categoryResults = await filterByCategory(category);
        final areaResults = await filterByArea(area);

        // Find recipes that exist in both results
        final categoryIds = categoryResults.map((r) => r.id).toSet();
        return areaResults
            .where((recipe) => categoryIds.contains(recipe.id))
            .toList();
      }

      // Single filter
      if (category != null) {
        return await filterByCategory(category);
      }

      if (area != null) {
        return await filterByArea(area);
      }

      // No filters, return default
      return await getDefaultRecipes();
    } catch (e) {
      throw RecipeServiceException('Failed to apply filters: $e');
    }
  }
}

// Custom exception for recipe service errors
class RecipeServiceException implements Exception {
  final String message;

  RecipeServiceException(this.message);

  @override
  String toString() => 'RecipeServiceException: $message';
}
