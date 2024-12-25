// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShowModelAdapter extends TypeAdapter<ShowModel> {
  @override
  final int typeId = 0;

  @override
  ShowModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShowModel(
      id: fields[0] as int,
      title: fields[1] as String,
      posterPath: fields[2] as String?,
      overview: fields[3] as String?,
      rating: fields[4] as double?,
      isMovie: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ShowModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.posterPath)
      ..writeByte(3)
      ..write(obj.overview)
      ..writeByte(4)
      ..write(obj.rating)
      ..writeByte(5)
      ..write(obj.isMovie);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShowModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
