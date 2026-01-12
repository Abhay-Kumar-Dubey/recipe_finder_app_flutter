part of 'recipe_list_bloc.dart';

@immutable
sealed class RecipeListState {}

final class RecipeListInitial extends RecipeListState {}

final class RecipeLoading extends RecipeListState {}

final class RecipeLoaded extends RecipeListState {
  final List<HomeRecipeModel> recipes;
  final List<CategoryListModel> categories;
  final List<AreaListModel> areas;

  final String? selectedCategory;
  final String? selectedArea;

  RecipeLoaded({
    required this.recipes,
    this.categories = const [],
    this.areas = const [],
    this.selectedArea,
    this.selectedCategory,
  });

  RecipeLoaded copyWith({
    List<HomeRecipeModel>? recipes,
    List<CategoryListModel>? categories,
    List<AreaListModel>? areas,
    String? selectedCategory,
    String? selectedArea,
  }) {
    return RecipeLoaded(
      recipes: recipes ?? this.recipes,
      categories: categories ?? this.categories,
      areas: areas ?? this.areas,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedArea: selectedArea ?? this.selectedArea,
    );
  }
}

final class FilterOptionsFetched extends RecipeListState {
  final List<CategoryListModel> categories;
  final List<AreaListModel> areas;
  FilterOptionsFetched({required this.categories, required this.areas});
}

final class RecipeError extends RecipeListState {
  final String message;
  
  RecipeError({required this.message});
}
