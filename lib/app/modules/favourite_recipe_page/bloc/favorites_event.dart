part of 'favorites_bloc.dart';

@immutable
sealed class FavoritesEvent {}

final class LoadFavorites extends FavoritesEvent {}

final class AddToFavorites extends FavoritesEvent {
  final String id;
  final String name;
  final String thumbnailUrl;

  AddToFavorites({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
  });
}

final class RemoveFromFavorites extends FavoritesEvent {
  final String recipeId;

  RemoveFromFavorites({required this.recipeId});
}

final class ClearAllFavorites extends FavoritesEvent {}

final class ToggleFavorite extends FavoritesEvent {
  final String id;
  final String name;
  final String thumbnailUrl;

  ToggleFavorite({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
  });
}