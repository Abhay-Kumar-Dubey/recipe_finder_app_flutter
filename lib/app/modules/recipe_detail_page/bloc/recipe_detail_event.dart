part of 'recipe_detail_bloc.dart';

@immutable
sealed class RecipeDetailEvent {}

final class fetchRecipeDetail extends RecipeDetailEvent {
  String mealId;
  fetchRecipeDetail({required this.mealId});
}
