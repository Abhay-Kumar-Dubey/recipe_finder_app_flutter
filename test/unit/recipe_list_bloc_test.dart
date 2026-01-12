import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_finder_app/app/data/models/area_list_model.dart';
import 'package:recipe_finder_app/app/data/models/category_list_model.dart';
import 'package:recipe_finder_app/app/data/models/home_recipe_model.dart';
import 'package:recipe_finder_app/app/modules/recipe_list_page/bloc/recipe_list_bloc.dart';

void main() {
  group('RecipeListBloc Unit Tests', () {
    late RecipeListBloc bloc;

    setUp(() {
      bloc = RecipeListBloc();
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is RecipeListInitial', () {
      expect(bloc.state, isA<RecipeListInitial>());
    });

    group('SortRecipes', () {
      final mockRecipes = [
        HomeRecipeModel(id: '1', name: 'Zebra Cake', thumbnailUrl: 'url1'),
        HomeRecipeModel(id: '2', name: 'Apple Pie', thumbnailUrl: 'url2'),
        HomeRecipeModel(id: '3', name: 'Banana Bread', thumbnailUrl: 'url3'),
      ];

      blocTest<RecipeListBloc, RecipeListState>(
        'sorts recipes in ascending order when descending is false',
        build: () => bloc,
        seed: () => RecipeLoaded(recipes: mockRecipes),
        act: (bloc) => bloc.add(SortRecipes(descending: false)),
        expect: () => [
          isA<RecipeLoaded>().having(
            (state) => state.recipes.map((r) => r.name).toList(),
            'sorted recipes',
            ['Apple Pie', 'Banana Bread', 'Zebra Cake'],
          ),
        ],
      );

      blocTest<RecipeListBloc, RecipeListState>(
        'sorts recipes in descending order when descending is true',
        build: () => bloc,
        seed: () => RecipeLoaded(recipes: mockRecipes),
        act: (bloc) => bloc.add(SortRecipes(descending: true)),
        expect: () => [
          isA<RecipeLoaded>().having(
            (state) => state.recipes.map((r) => r.name).toList(),
            'sorted recipes',
            ['Zebra Cake', 'Banana Bread', 'Apple Pie'],
          ),
        ],
      );
    });

    group('SearchQueryChanged', () {
      blocTest<RecipeListBloc, RecipeListState>(
        'returns early when search query is empty',
        build: () => bloc,
        seed: () => RecipeLoaded(recipes: []),
        act: (bloc) => bloc.add(SearchQueryChanged('', null, null)),
        wait: const Duration(milliseconds: 600),
        expect: () => [],
      );

      blocTest<RecipeListBloc, RecipeListState>(
        'returns early when search query is whitespace only',
        build: () => bloc,
        seed: () => RecipeLoaded(recipes: []),
        act: (bloc) => bloc.add(SearchQueryChanged('   ', null, null)),
        wait: const Duration(milliseconds: 600),
        expect: () => [],
      );
    });

    group('State Management', () {
      test('RecipeLoaded copyWith should work correctly', () {
        // Arrange
        final originalState = RecipeLoaded(
          recipes: [HomeRecipeModel(id: '1', name: 'Test', thumbnailUrl: 'url')],
          categories: [CategoryListModel(name: 'Beef')],
          areas: [AreaListModel(name: 'Italian')],
          selectedCategory: 'Beef',
          selectedArea: 'Italian',
        );

        // Act
        final newState = originalState.copyWith(
          selectedCategory: 'Chicken',
        );

        // Assert
        expect(newState.selectedCategory, 'Chicken');
        expect(newState.selectedArea, 'Italian'); // Should remain unchanged
        expect(newState.recipes.length, 1);
        expect(newState.categories.length, 1);
        expect(newState.areas.length, 1);
      });

      test('RecipeError should contain error message', () {
        // Act
        final errorState = RecipeError(message: 'Test error message');

        // Assert
        expect(errorState.message, 'Test error message');
      });

      test('FilterOptionsFetched should contain categories and areas', () {
        // Arrange
        final categories = [CategoryListModel(name: 'Beef')];
        final areas = [AreaListModel(name: 'Italian')];

        // Act
        final state = FilterOptionsFetched(categories: categories, areas: areas);

        // Assert
        expect(state.categories.length, 1);
        expect(state.areas.length, 1);
        expect(state.categories.first.name, 'Beef');
        expect(state.areas.first.name, 'Italian');
      });
    });

    group('Event Classes', () {
      test('applyFilter should accept category and area parameters', () {
        // Act
        final event = applyFilter(category: 'Beef', area: 'Italian');

        // Assert
        expect(event.category, 'Beef');
        expect(event.area, 'Italian');
      });

      test('applyFilter should handle null parameters', () {
        // Act
        final event = applyFilter();

        // Assert
        expect(event.category, isNull);
        expect(event.area, isNull);
      });

      test('SortRecipes should have descending parameter', () {
        // Act
        final event1 = SortRecipes(descending: true);
        final event2 = SortRecipes(descending: false);
        final event3 = SortRecipes(); // Default should be false

        // Assert
        expect(event1.descending, true);
        expect(event2.descending, false);
        expect(event3.descending, false);
      });

      test('SearchQueryChanged should contain query and filter parameters', () {
        // Act
        final event = SearchQueryChanged('chicken', 'Italian', 'Beef');

        // Assert
        expect(event.query, 'chicken');
        expect(event.area, 'Italian');
        expect(event.category, 'Beef');
      });
    });

    group('Debounce Functionality', () {
      test('debounce transformer should be configured correctly', () {
        // This tests that the debounce transformer exists and can be created
        final transformer = bloc.debounce<SearchQueryChanged>(
          const Duration(milliseconds: 500),
        );
        
        expect(transformer, isNotNull);
      });
    });

    group('Business Logic', () {
      test('should handle recipe list intersection correctly', () {
        // Arrange
        final recipes1 = [
          HomeRecipeModel(id: '1', name: 'Recipe 1', thumbnailUrl: 'url1'),
          HomeRecipeModel(id: '2', name: 'Recipe 2', thumbnailUrl: 'url2'),
          HomeRecipeModel(id: '3', name: 'Recipe 3', thumbnailUrl: 'url3'),
        ];

        final recipes2 = [
          HomeRecipeModel(id: '2', name: 'Recipe 2', thumbnailUrl: 'url2'),
          HomeRecipeModel(id: '4', name: 'Recipe 4', thumbnailUrl: 'url4'),
        ];

        // Act - Simulate the intersection logic used in filterRecipes
        final ids1 = recipes1.map((r) => r.id).toSet();
        final intersection = recipes2.where((recipe) => ids1.contains(recipe.id)).toList();

        // Assert
        expect(intersection.length, 1);
        expect(intersection.first.id, '2');
      });

      test('should handle empty recipe lists', () {
        // Arrange
        final List<HomeRecipeModel> emptyList = [];

        // Act
        final sorted = List<HomeRecipeModel>.from(emptyList);
        sorted.sort((a, b) => a.name.compareTo(b.name));

        // Assert
        expect(sorted, isEmpty);
      });
    });
  });
}