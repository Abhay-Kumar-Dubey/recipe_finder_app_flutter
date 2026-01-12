import 'package:hive/hive.dart';

part 'favorite_recipe_model.g.dart';

@HiveType(typeId: 0)
class FavoriteRecipeModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String thumbnailUrl;

  @HiveField(3)
  final DateTime addedAt;

  FavoriteRecipeModel({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.addedAt,
  });

  factory FavoriteRecipeModel.fromHomeRecipe({
    required String id,
    required String name,
    required String thumbnailUrl,
  }) {
    return FavoriteRecipeModel(
      id: id,
      name: name,
      thumbnailUrl: thumbnailUrl,
      addedAt: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'FavoriteRecipeModel(id: $id, name: $name, thumbnailUrl: $thumbnailUrl, addedAt: $addedAt)';
  }
}