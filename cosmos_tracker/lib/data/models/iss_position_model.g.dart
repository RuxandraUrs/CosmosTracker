part of 'iss_position_model.dart';

class IssPositionModelAdapter extends TypeAdapter<IssPositionModel> {
  @override
  final int typeId = 0;

  @override
  IssPositionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IssPositionModel(
      latitude: fields[0] as double,
      longitude: fields[1] as double,
      locationName: fields[2] as String?,
      timestamp: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, IssPositionModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude)
      ..writeByte(2)
      ..write(obj.locationName)
      ..writeByte(3)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssPositionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
