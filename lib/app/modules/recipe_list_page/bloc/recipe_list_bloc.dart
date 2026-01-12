import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:recipe_finder_app/app/data/models/area_list_model.dart';
import 'package:recipe_finder_app/app/data/models/category_list_model.dart';
import 'package:recipe_finder_app/app/data/models/home_recipe_model.dart';
import 'package:recipe_finder_app/app/services/recipe_service.dart';
import 'package:rxdart/rxdart.dart';

part 'recipe_list_event.dart';
part 'recipe_list_state.dart';

class RecipeListBloc extends Bloc<RecipeListEvent, RecipeListState> {
  List<HomeRecipeModel> _recipes = [];
  List<CategoryListModel> _categories = [];
  List<AreaListModel> _areas = [];

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }

  RecipeListBloc() : super(RecipeListInitial()) {
    on<RecipeListEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<fetchRecipeOnHome>(_onFetchRecipeOnHome);
    on<fetchFilterCategories>(_onFetchFilterCategories);
    on<applyFilter>(_onApplyFilter);
    on<clearFilters>(_onClearFilters);
    on<SortRecipes>(_onSortedRecipe);
    on<SearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }
  // Bloc function to fetch data on home screen , triggered when FetchRecipeOnHome event is triggered
  Future<void> _onFetchRecipeOnHome(
    fetchRecipeOnHome event,
    Emitter<RecipeListState> emit,
  ) async {
    emit(RecipeLoading());
    try {
      final recipes = await RecipeService.getDefaultRecipes();

      _recipes.clear();
      _recipes.addAll(recipes);

      emit(
        RecipeLoaded(recipes: _recipes, categories: _categories, areas: _areas),
      );
    } catch (e) {
      emit(RecipeError(message: 'Failed to load recipes: $e'));
    }
  }

  //Bloc function to sort data on the home page
  void _onSortedRecipe(SortRecipes event, Emitter<RecipeListState> emit) {
    final sorted = List<HomeRecipeModel>.from((state as RecipeLoaded).recipes);

    if (event.descending) {
      sorted.sort((a, b) => b.name.compareTo(a.name));
    } else {
      sorted.sort((a, b) => a.name.compareTo(b.name));
    }

    emit((state as RecipeLoaded).copyWith(recipes: sorted));
  }

  //Bloc function triggered upon 500ms of debouncing when user types something in search , multi filter is also implemented here
  //First select filter in filter section and then search some text to add all 3 (name,category and area) filters
  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<RecipeListState> emit,
  ) async {
    final query = event.query.trim();

    // 🔹 CASE 1: Empty search → fallback to filters
    if (query.isEmpty) {
      add(applyFilter(category: event.category, area: event.area));
      return;
    }

    try {
      //  Search by name using service
      final searchResults = await RecipeService.searchRecipes(query);

      List<HomeRecipeModel> filteredRecipes = searchResults;
      //Search when both category and area filter is applied
      if (event.category != null && event.area != null) {
        List<HomeRecipeModel> filteredCategoryResult =
            await RecipeService.filterByCategory(event.category!);
        final categoryIds = filteredCategoryResult.map((e) => e.id).toSet();
        List<HomeRecipeModel> filteredCategoryRecipe = filteredRecipes
            .where((recipe) => categoryIds.contains(recipe.id))
            .toList();
        List<HomeRecipeModel> filteredAreaResult =
            await RecipeService.filterByArea(event.area!);
        final AreaIds = filteredAreaResult.map((e) => e.id).toSet();
        List<HomeRecipeModel> finalFilteredRecipe = filteredCategoryRecipe
            .where((recipe) => AreaIds.contains(recipe.id))
            .toList();
        emit((state as RecipeLoaded).copyWith(recipes: finalFilteredRecipe));
        //when name and category both are applied
      } else if (event.area == null && event.category != null) {
        List<HomeRecipeModel> filteredCategoryResult =
            await RecipeService.filterByCategory(event.category!);
        final categoryIds = filteredCategoryResult.map((e) => e.id).toSet();
        List<HomeRecipeModel> filteredCategoryRecipe = filteredRecipes
            .where((recipe) => categoryIds.contains(recipe.id))
            .toList();
        emit((state as RecipeLoaded).copyWith(recipes: filteredCategoryRecipe));
        //when name and area both are applied
      } else if (event.category == null && event.area != null) {
        List<HomeRecipeModel> filteredAreaResult =
            await RecipeService.filterByArea(event.area!);
        final AreaIds = filteredAreaResult.map((e) => e.id).toSet();
        List<HomeRecipeModel> finalFilteredRecipe = filteredRecipes
            .where((recipe) => AreaIds.contains(recipe.id))
            .toList();
        print(finalFilteredRecipe);
        emit((state as RecipeLoaded).copyWith(recipes: finalFilteredRecipe));
      } else {
        emit((state as RecipeLoaded).copyWith(recipes: filteredRecipes));
      }
    } catch (e) {
      emit((state as RecipeLoaded).copyWith(recipes: []));
    }
  }

  // Bloc function to fetch different options provided by TheMealDB for category and area
  Future<void> _onFetchFilterCategories(
    fetchFilterCategories event,
    Emitter<RecipeListState> emit,
  ) async {
    try {
      final categories = await RecipeService.getCategories();
      final areas = await RecipeService.getAreas();

      _categories.clear();
      _categories.addAll(categories);
      _areas.clear();
      _areas.addAll(areas);

      // Update the current state with filter options
      if (state is RecipeLoaded) {
        emit(
          (state as RecipeLoaded).copyWith(
            categories: _categories,
            areas: _areas,
          ),
        );
      } else {
        emit(
          RecipeLoaded(
            recipes: _recipes,
            categories: _categories,
            areas: _areas,
          ),
        );
      }
    } catch (e) {
      emit(RecipeError(message: 'Failed to load filter options: $e'));
    }
  }

  // Bloc Function when user just selects category or area filter , or both.
  Future<void> _onApplyFilter(
    applyFilter event,
    Emitter<RecipeListState> emit,
  ) async {
    emit(RecipeLoading());

    try {
      final recipes = await RecipeService.filterRecipes(
        category: event.category,
        area: event.area,
      );

      emit(
        RecipeLoaded(
          recipes: recipes,
          categories: _categories,
          areas: _areas,
          selectedCategory: event.category,
          selectedArea: event.area,
        ),
      );
    } catch (e) {
      emit(RecipeError(message: 'Failed to apply filters: $e'));
    }
  }

  //Bloc function to clear any filter applied
  Future<void> _onClearFilters(
    clearFilters event,
    Emitter<RecipeListState> emit,
  ) async {
    // Reset to default Indian recipes
    add(fetchRecipeOnHome());
  }
}
