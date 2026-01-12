import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_finder_app/app/data/models/favorite_recipe_model.dart';
import 'package:recipe_finder_app/app/data/models/home_recipe_model.dart';
import 'package:recipe_finder_app/app/data/models/recipe_detail_model.dart';
import 'package:recipe_finder_app/app/data/models/category_list_model.dart';
import 'package:recipe_finder_app/app/data/models/area_list_model.dart';

void main() {
  group('Model Serialization/Deserialization Tests', () {
    group('HomeRecipeModel', () {
      test('should create model from JSON correctly', () {
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

      test('should handle null values in JSON gracefully', () {
        // Arrange
        final json = {
          'idMeal': null,
          'strMeal': null,
          'strMealThumb': null
        };

        // Act
        final model = HomeRecipeModel.fromJson(json);

        // Assert
        expect(model.id, '');
        expect(model.name, '');
        expect(model.thumbnailUrl, '');
      });

      test('should convert model to JSON correctly', () {
        // Arrange
        final model = HomeRecipeModel(
          id: '52977',
          name: 'Corba',
          thumbnailUrl: 'https://www.themealdb.com/images/media/meals/58oia61564916529.jpg',
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json['id'], '52977');
        expect(json['name'], 'Corba');
        expect(json['thumbnailUrl'], 'https://www.themealdb.com/images/media/meals/58oia61564916529.jpg');
      });
    });
    group('RecipeDetailModel', () {
      test('should create model from JSON with ingredients correctly', () {
        // Arrange
        final json = {
          'idMeal': '52977',
          'strMeal': 'Corba',
          'strCategory': 'Side',
          'strArea': 'Turkish',
          'strInstructions': 'Pick through your lentils...',
          'strMealThumb': 'https://www.themealdb.com/images/media/meals/58oia61564916529.jpg',
          'strTags': 'Soup',
          'strYoutube': 'https://www.youtube.com/watch?v=VVnZd8A84z4',
          'strIngredient1': 'Lentils',
          'strMeasure1': '1 cup',
          'strIngredient2': 'Onion',
          'strMeasure2': '1 large',
          'strIngredient3': 'Carrots',
          'strMeasure3': '1 large',
          'strIngredient4': '',
          'strMeasure4': '',
        };

        // Act
        final model = RecipeDetailModel.fromJson(json);

        // Assert
        expect(model.id, '52977');
        expect(model.name, 'Corba');
        expect(model.category, 'Side');
        expect(model.area, 'Turkish');
        expect(model.instructions, 'Pick through your lentils...');
        expect(model.thumbnailUrl, 'https://www.themealdb.com/images/media/meals/58oia61564916529.jpg');
        expect(model.tags, 'Soup');
        expect(model.youtubeUrl, 'https://www.youtube.com/watch?v=VVnZd8A84z4');
        expect(model.ingredients.length, 3);
        expect(model.ingredients[0].name, 'Lentils');
        expect(model.ingredients[0].measure, '1 cup');
        expect(model.ingredients[1].name, 'Onion');
        expect(model.ingredients[1].measure, '1 large');
      });

      test('should handle empty ingredients correctly', () {
        // Arrange
        final json = {
          'idMeal': '52977',
          'strMeal': 'Corba',
          'strCategory': 'Side',
          'strArea': 'Turkish',
          'strInstructions': 'Instructions...',
          'strMealThumb': 'https://example.com/image.jpg',
        };

        // Act
        final model = RecipeDetailModel.fromJson(json);

        // Assert
        expect(model.ingredients, isEmpty);
      });

      test('should handle null optional fields correctly', () {
        // Arrange
        final json = {
          'idMeal': '52977',
          'strMeal': 'Corba',
          'strCategory': 'Side',
          'strArea': 'Turkish',
          'strInstructions': 'Instructions...',
          'strMealThumb': 'https://example.com/image.jpg',
          'strTags': null,
          'strYoutube': null,
        };

        // Act
        final model = RecipeDetailModel.fromJson(json);

        // Assert
        expect(model.tags, isNull);
        expect(model.youtubeUrl, isNull);
      });
    });

    group('Ingredient', () {
      test('should create ingredient with name and measure', () {
        // Act
        final ingredient = Ingredient(name: 'Lentils', measure: '1 cup');

        // Assert
        expect(ingredient.name, 'Lentils');
        expect(ingredient.measure, '1 cup');
      });
    });

    group('FavoriteRecipeModel', () {
      test('should create from HomeRecipe factory correctly', () {
        // Act
        final favorite = FavoriteRecipeModel.fromHomeRecipe(
          id: '52977',
          name: 'Corba',
          thumbnailUrl: 'https://www.themealdb.com/images/media/meals/58oia61564916529.jpg',
        );

        // Assert
        expect(favorite.id, '52977');
        expect(favorite.name, 'Corba');
        expect(favorite.thumbnailUrl, 'https://www.themealdb.com/images/media/meals/58oia61564916529.jpg');
        expect(favorite.addedAt, isA<DateTime>());
        expect(favorite.addedAt.isBefore(DateTime.now().add(Duration(seconds: 1))), true);
      });

      test('should create with constructor correctly', () {
        // Arrange
        final now = DateTime.now();

        // Act
        final favorite = FavoriteRecipeModel(
          id: '52977',
          name: 'Corba',
          thumbnailUrl: 'https://www.themealdb.com/images/media/meals/58oia61564916529.jpg',
          addedAt: now,
        );

        // Assert
        expect(favorite.id, '52977');
        expect(favorite.name, 'Corba');
        expect(favorite.thumbnailUrl, 'https://www.themealdb.com/images/media/meals/58oia61564916529.jpg');
        expect(favorite.addedAt, now);
      });

      test('should have correct toString representation', () {
        // Arrange
        final now = DateTime.now();
        final favorite = FavoriteRecipeModel(
          id: '52977',
          name: 'Corba',
          thumbnailUrl: 'https://www.themealdb.com/images/media/meals/58oia61564916529.jpg',
          addedAt: now,
        );

        // Act
        final stringRepresentation = favorite.toString();

        // Assert
        expect(stringRepresentation, contains('52977'));
        expect(stringRepresentation, contains('Corba'));
        expect(stringRepresentation, contains('https://www.themealdb.com/images/media/meals/58oia61564916529.jpg'));
        expect(stringRepresentation, contains(now.toString()));
      });
    });

    group('CategoryListModel', () {
      test('should create model from JSON correctly', () {
        // Arrange
        final json = {'strCategory': 'Beef'};

        // Act
        final model = CategoryListModel.fromJson(json);

        // Assert
        expect(model.name, 'Beef');
      });

      test('should handle null values in JSON gracefully', () {
        // Arrange
        final json = {'strCategory': null};

        // Act
        final model = CategoryListModel.fromJson(json);

        // Assert
        expect(model.name, '');
      });

      test('should convert model to JSON correctly', () {
        // Arrange
        final model = CategoryListModel(name: 'Chicken');

        // Act
        final json = model.toJson();

        // Assert
        expect(json['name'], 'Chicken');
      });
    });

    group('AreaListModel', () {
      test('should create model from JSON correctly', () {
        // Arrange
        final json = {'strArea': 'Italian'};

        // Act
        final model = AreaListModel.fromJson(json);

        // Assert
        expect(model.name, 'Italian');
      });

      test('should handle null values in JSON gracefully', () {
        // Arrange
        final json = {'strArea': null};

        // Act
        final model = AreaListModel.fromJson(json);

        // Assert
        expect(model.name, '');
      });

      test('should convert model to JSON correctly', () {
        // Arrange
        final model = AreaListModel(name: 'Mexican');

        // Act
        final json = model.toJson();

        // Assert
        expect(json['name'], 'Mexican');
      });

      test('should handle empty string values', () {
        // Arrange
        final json = {'strArea': ''};

        // Act
        final model = AreaListModel.fromJson(json);

        // Assert
        expect(model.name, '');
      });
    });
  });
}