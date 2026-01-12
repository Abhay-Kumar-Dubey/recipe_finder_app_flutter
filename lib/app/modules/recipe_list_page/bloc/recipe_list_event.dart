part of 'recipe_list_bloc.dart';

@immutable
sealed class RecipeListEvent {}

final class fetchRecipeOnHome extends RecipeListEvent {}

final class fetchFilterCategories extends RecipeListEvent {}

final class applyFilter extends RecipeListEvent {
  String? category;
  String? area;
  applyFilter({this.area, this.category});
}

class SortRecipes extends RecipeListEvent {
  final bool descending;
  SortRecipes({this.descending = false});
}

final class clearFilters extends RecipeListEvent {}

class SearchQueryChanged extends RecipeListEvent {
  final String query;
  String? category;
  String? area;
  SearchQueryChanged(this.query, this.area, this.category);
}
