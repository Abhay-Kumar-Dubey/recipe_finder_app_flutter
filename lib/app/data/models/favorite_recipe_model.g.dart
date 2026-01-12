// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_recipe_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteRecipeModelAdapter extends TypeAdapter<FavoriteRecipeModel> {
  @override
  final int typeId = 0;

  @override
  FavoriteRecipeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteRecipeModel(
      id: fields[0] as String,
      name: fields[1] as String,
      thumbnailUrl: fields[2] as String,
      addedAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteRecipeModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.thumbnailUrl)
      ..writeByte(3)
      ..write(obj.addedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteRecipeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
