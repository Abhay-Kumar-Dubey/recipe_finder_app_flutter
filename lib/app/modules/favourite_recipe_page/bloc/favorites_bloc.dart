import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:recipe_finder_app/app/data/models/favorite_recipe_model.dart';
import 'package:recipe_finder_app/app/services/favorites_service.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
    on<ClearAllFavorites>(_onClearAllFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
  }
  //Bloc function to get the favorite list from the storage
  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      emit(FavoritesLoading());

      final favorites = FavoritesService.getAllFavorites();
      final favoriteIds = favorites.map((f) => f.id).toSet();

      emit(FavoritesLoaded(favorites: favorites, favoriteIds: favoriteIds));
    } catch (e) {
      emit(FavoritesError(message: 'Failed to load favorites: $e'));
    }
  }

  //Function to add meal to fav list
  Future<void> _onAddToFavorites(
    AddToFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final favorite = FavoriteRecipeModel.fromHomeRecipe(
        id: event.id,
        name: event.name,
        thumbnailUrl: event.thumbnailUrl,
      );

      await FavoritesService.addToFavorites(favorite);

      add(LoadFavorites());
    } catch (e) {
      emit(FavoritesError(message: 'Failed to add to favorites: $e'));
    }
  }

  //Function to Remove meal from fav list
  Future<void> _onRemoveFromFavorites(
    RemoveFromFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await FavoritesService.removeFromFavorites(event.recipeId);

      add(LoadFavorites());
    } catch (e) {
      emit(FavoritesError(message: 'Failed to remove from favorites: $e'));
    }
  }

  //Function to clean fav list or remove all meals from fav list
  Future<void> _onClearAllFavorites(
    ClearAllFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await FavoritesService.clearAllFavorites();

      emit(FavoritesLoaded(favorites: [], favoriteIds: {}));
    } catch (e) {
      emit(FavoritesError(message: 'Failed to clear favorites: $e'));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      if (FavoritesService.isFavorite(event.id)) {
        await FavoritesService.removeFromFavorites(event.id);
      } else {
        final favorite = FavoriteRecipeModel.fromHomeRecipe(
          id: event.id,
          name: event.name,
          thumbnailUrl: event.thumbnailUrl,
        );
        await FavoritesService.addToFavorites(favorite);
      }

      add(LoadFavorites());
    } catch (e) {
      emit(FavoritesError(message: 'Failed to toggle favorite: $e'));
    }
  }
}
