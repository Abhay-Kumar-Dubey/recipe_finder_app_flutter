import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:recipe_finder_app/app/data/models/recipe_detail_model.dart';
import 'package:recipe_finder_app/app/services/recipe_service.dart';

part 'recipe_detail_event.dart';
part 'recipe_detail_state.dart';

class RecipeDetailBloc extends Bloc<RecipeDetailEvent, RecipeDetailState> {
  RecipeDetailBloc() : super(RecipeDetailInitial()) {
    on<RecipeDetailEvent>((event, emit) {});
    on<fetchRecipeDetail>(_fetchRecipeDetail);
  }
}

//Bloc Function to fetch Details of the meal using the MealId
Future<void> _fetchRecipeDetail(
  fetchRecipeDetail event,
  Emitter<RecipeDetailState> emit,
) async {
  emit(RecipeDetailLoading());
  try {
    final recipeDetails = await RecipeService.getRecipeDetails(event.mealId);

    if (recipeDetails.isNotEmpty) {
      emit(recipieDetailfetched(recipeDetail: recipeDetails));
    } else {
      emit(RecipeDetailError(message: 'Recipe not found'));
    }
  } catch (e) {
    emit(RecipeDetailError(message: 'Failed to load recipe details: $e'));
  }
}
