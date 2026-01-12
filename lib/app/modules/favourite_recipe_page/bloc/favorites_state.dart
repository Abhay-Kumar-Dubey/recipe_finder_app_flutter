part of 'favorites_bloc.dart';

@immutable
sealed class FavoritesState {}

final class FavoritesInitial extends FavoritesState {}

final class FavoritesLoading extends FavoritesState {}

final class FavoritesLoaded extends FavoritesState {
  final List<FavoriteRecipeModel> favorites;
  final Set<String> favoriteIds;

  FavoritesLoaded({
    required this.favorites,
    required this.favoriteIds,
  });

  FavoritesLoaded copyWith({
    List<FavoriteRecipeModel>? favorites,
    Set<String>? favoriteIds,
  }) {
    return FavoritesLoaded(
      favorites: favorites ?? this.favorites,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }
}

final class FavoritesError extends FavoritesState {
  final String message;

  FavoritesError({required this.message});
}