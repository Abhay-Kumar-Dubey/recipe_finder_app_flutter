import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_finder_app/app/data/models/favorite_recipe_model.dart';
import 'package:recipe_finder_app/app/services/favorites_service.dart';

void main() {
  group('FavoritesService Unit Tests', () {
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

    group('Service Logic Tests', () {
      test('should handle favorite recipe data correctly', () {
        // Test the data structure and logic without Hive dependency
        final favorites = <String, FavoriteRecipeModel>{};
        
        // Simulate adding a favorite
        final favorite = FavoriteRecipeModel.fromHomeRecipe(
          id: '52977',
          name: 'Corba',
          thumbnailUrl: 'https://www.themealdb.com/images/media/meals/58oia61564916529.jpg',
        );
        
        favorites[favorite.id] = favorite;
        
        // Test contains logic
        expect(favorites.containsKey('52977'), true);
        expect(favorites.containsKey('nonexistent'), false);
        
        // Test retrieval
        final retrieved = favorites['52977'];
        expect(retrieved, isNotNull);
        expect(retrieved!.name, 'Corba');
        
        // Test removal
        favorites.remove('52977');
        expect(favorites.containsKey('52977'), false);
        expect(favorites.length, 0);
      });

      test('should handle multiple favorites correctly', () {
        final favorites = <String, FavoriteRecipeModel>{};
        
        final favorite1 = FavoriteRecipeModel.fromHomeRecipe(
          id: '52977',
          name: 'Corba',
          thumbnailUrl: 'https://www.themealdb.com/images/media/meals/58oia61564916529.jpg',
        );
        
        final favorite2 = FavoriteRecipeModel.fromHomeRecipe(
          id: '52978',
          name: 'Kumpir',
          thumbnailUrl: 'https://www.themealdb.com/images/media/meals/mlchx21564916997.jpg',
        );
        
        favorites[favorite1.id] = favorite1;
        favorites[favorite2.id] = favorite2;
        
        expect(favorites.length, 2);
        expect(favorites.values.map((f) => f.name).toList(), contains('Corba'));
        expect(favorites.values.map((f) => f.name).toList(), contains('Kumpir'));
      });

      test('should handle sorting by date correctly', () {
        final now = DateTime.now();
        final earlier = now.subtract(Duration(hours: 1));
        
        final favorite1 = FavoriteRecipeModel(
          id: '1',
          name: 'Recipe 1',
          thumbnailUrl: 'url1',
          addedAt: earlier,
        );
        
        final favorite2 = FavoriteRecipeModel(
          id: '2',
          name: 'Recipe 2',
          thumbnailUrl: 'url2',
          addedAt: now,
        );
        
        final favorites = [favorite1, favorite2];
        
        // Sort by newest first (descending)
        favorites.sort((a, b) => b.addedAt.compareTo(a.addedAt));
        
        expect(favorites.first.name, 'Recipe 2');
        expect(favorites.last.name, 'Recipe 1');
      });

      test('should handle clear operation correctly', () {
        final favorites = <String, FavoriteRecipeModel>{};
        
        // Add some favorites
        favorites['1'] = FavoriteRecipeModel.fromHomeRecipe(
          id: '1',
          name: 'Recipe 1',
          thumbnailUrl: 'url1',
        );
        favorites['2'] = FavoriteRecipeModel.fromHomeRecipe(
          id: '2',
          name: 'Recipe 2',
          thumbnailUrl: 'url2',
        );
        
        expect(favorites.length, 2);
        
        // Clear all
        favorites.clear();
        
        expect(favorites.length, 0);
        expect(favorites.isEmpty, true);
      });
    });
  });
}