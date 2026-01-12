import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_finder_app/app/data/models/area_list_model.dart';
import 'package:recipe_finder_app/app/data/models/category_list_model.dart';
import 'package:recipe_finder_app/app/data/models/home_recipe_model.dart';
import 'package:recipe_finder_app/app/data/models/recipe_detail_model.dart';
import 'package:recipe_finder_app/app/services/recipe_service.dart';

void main() {
  group('RecipeService Unit Tests', () {
    group('Data Processing Logic', () {
      test('should handle empty search query correctly', () async {
        // Act
        final result = await RecipeService.searchRecipes('');

        // Assert
        expect(result, isEmpty);
      });

      test('should handle whitespace-only search query', () async {
        // Act
        final result = await RecipeService.searchRecipes('   ');

        // Assert
        expect(result, isEmpty);
      });

      test('should create HomeRecipeModel from JSON correctly', () {
        // Arrange
        final json = {
          'idMeal': '52977',
          'strMeal': 'Corba',
          'strMealThumb': 'https://www.themealdb.com/images/media/meals/58oia61564916529.jpg'
        };

        // Act
        final model = HomeRecipeModel.fromJson(json);

        // Assert
        expect(model.id, '52977');
        expect(model.name, 'Corba');
        expect(model.thumbnailUrl, 'https://www.themealdb.com/images/media/meals/58oia61564916529.jpg');
      });

      test('should create RecipeDetailModel from JSON correctly', () {
        // Arrange
        final json = {
          'idMeal': '52977',
          'strMeal': 'Corba',
          'strCategory': 'Side',
          'strArea': 'Turkish',
          'strInstructions': 'Pick through your lentils...',
          'strMealThumb': 'https://www.themealdb.com/images/media/meals/58oia61564916529.jpg',
          'strIngredient1': 'Lentils',
          'strMeasure1': '1 cup',
          'strIngredient2': 'Onion',
          'strMeasure2': '1 large',
        };

        // Act
        final model = RecipeDetailModel.fromJson(json);

        // Assert
        expect(model.id, '52977');
        expect(model.name, 'Corba');
        expect(model.category, 'Side');
        expect(model.area, 'Turkish');
        expect(model.ingredients.length, 2);
        expect(model.ingredients.first.name, 'Lentils');
        expect(model.ingredients.first.measure, '1 cup');
      });

      test('should create CategoryListModel from JSON correctly', () {
        // Arrange
        final json = {'strCategory': 'Beef'};

        // Act
        final model = CategoryListModel.fromJson(json);

        // Assert
        expect(model.name, 'Beef');
      });

      test('should create AreaListModel from JSON correctly', () {
        // Arrange
        final json = {'strArea': 'Italian'};

        // Act
        final model = AreaListModel.fromJson(json);

        // Assert
        expect(model.name, 'Italian');
      });
    });

    group('Filter Logic', () {
      test('should handle recipe intersection logic correctly', () {
        // Arrange
        final categoryRecipes = [
          HomeRecipeModel(id: '1', name: 'Recipe 1', thumbnailUrl: 'url1'),
          HomeRecipeModel(id: '2', name: 'Recipe 2', thumbnailUrl: 'url2'),
          HomeRecipeModel(id: '3', name: 'Recipe 3', thumbnailUrl: 'url3'),
        ];

        final areaRecipes = [
          HomeRecipeModel(id: '2', name: 'Recipe 2', thumbnailUrl: 'url2'),
          HomeRecipeModel(id: '4', name: 'Recipe 4', thumbnailUrl: 'url4'),
        ];

        // Act - Simulate intersection logic
        final categoryIds = categoryRecipes.map((r) => r.id).toSet();
        final intersection = areaRecipes.where((recipe) => categoryIds.contains(recipe.id)).toList();

        // Assert
        expect(intersection.length, 1);
        expect(intersection.first.id, '2');
        expect(intersection.first.name, 'Recipe 2');
      });

      test('should handle empty intersection correctly', () {
        // Arrange
        final categoryRecipes = [
          HomeRecipeModel(id: '1', name: 'Recipe 1', thumbnailUrl: 'url1'),
          HomeRecipeModel(id: '2', name: 'Recipe 2', thumbnailUrl: 'url2'),
        ];

        final areaRecipes = [
          HomeRecipeModel(id: '3', name: 'Recipe 3', thumbnailUrl: 'url3'),
          HomeRecipeModel(id: '4', name: 'Recipe 4', thumbnailUrl: 'url4'),
        ];

        // Act - Simulate intersection logic
        final categoryIds = categoryRecipes.map((r) => r.id).toSet();
        final intersection = areaRecipes.where((recipe) => categoryIds.contains(recipe.id)).toList();

        // Assert
        expect(intersection, isEmpty);
      });
    });

    group('Exception Handling', () {
      test('should create RecipeServiceException correctly', () {
        // Act
        final exception = RecipeServiceException('Test error message');

        // Assert
        expect(exception.message, 'Test error message');
        expect(exception.toString(), 'RecipeServiceException: Test error message');
      });

      test('should handle different error messages', () {
        final exception1 = RecipeServiceException('Network error');
        final exception2 = RecipeServiceException('Parsing error');

        expect(exception1.message, 'Network error');
        expect(exception2.message, 'Parsing error');
        expect(exception1.toString(), contains('Network error'));
        expect(exception2.toString(), contains('Parsing error'));
      });
    });

    group('Data Transformation', () {
      test('should transform list of JSON to list of models', () {
        // Arrange
        final jsonList = [
          {
            'idMeal': '1',
            'strMeal': 'Recipe 1',
            'strMealThumb': 'url1'
          },
          {
            'idMeal': '2',
            'strMeal': 'Recipe 2',
            'strMealThumb': 'url2'
          }
        ];

        // Act
        final models = jsonList.map((json) => HomeRecipeModel.fromJson(json)).toList();

        // Assert
        expect(models.length, 2);
        expect(models.first.name, 'Recipe 1');
        expect(models.last.name, 'Recipe 2');
      });

      test('should handle empty JSON list', () {
        // Arrange
        final List<Map<String, dynamic>> jsonList = [];

        // Act
        final models = jsonList.map((json) => HomeRecipeModel.fromJson(json)).toList();

        // Assert
        expect(models, isEmpty);
      });
    });
  });
}