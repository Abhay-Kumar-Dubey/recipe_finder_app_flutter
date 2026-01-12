part of 'recipe_detail_bloc.dart';

@immutable
sealed class RecipeDetailState {}

final class RecipeDetailInitial extends RecipeDetailState {}

final class RecipeDetailLoading extends RecipeDetailState {}

final class recipieDetailfetched extends RecipeDetailState {
  final List<RecipeDetailModel> recipeDetail;
  recipieDetailfetched({required this.recipeDetail});
}

final class RecipeDetailError extends RecipeDetailState {
  final String message;
  
  RecipeDetailError({required this.message});
}
