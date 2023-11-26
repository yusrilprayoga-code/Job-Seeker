// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlistJobs.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WishlistJobsAdapter extends TypeAdapter<WishlistJobs> {
  @override
  final int typeId = 0;

  @override
  WishlistJobs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WishlistJobs(
      created: fields[0] as String?,
      expires: fields[1] as String?,
      sourced: fields[2] as String?,
      unique: fields[3] as int?,
      companyName: fields[4] as String?,
      companyUrl: fields[5] as String?,
      title: fields[6] as String?,
      description: fields[7] as String?,
      link: fields[8] as String?,
      category: (fields[9] as List?)?.cast<String>(),
      location: fields[10] as String?,
      country: fields[11] as String?,
      salary: fields[12] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, WishlistJobs obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.created)
      ..writeByte(1)
      ..write(obj.expires)
      ..writeByte(2)
      ..write(obj.sourced)
      ..writeByte(3)
      ..write(obj.unique)
      ..writeByte(4)
      ..write(obj.companyName)
      ..writeByte(5)
      ..write(obj.companyUrl)
      ..writeByte(6)
      ..write(obj.title)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.link)
      ..writeByte(9)
      ..write(obj.category)
      ..writeByte(10)
      ..write(obj.location)
      ..writeByte(11)
      ..write(obj.country)
      ..writeByte(12)
      ..write(obj.salary);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WishlistJobsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
