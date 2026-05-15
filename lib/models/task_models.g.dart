// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 0;

  @override
  TaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskModel(
      id: fields[0] as String,
      title: fields[1] as String,
      note: fields[2] as String?,
      quadrant: fields[3] as QuadrantType,
      dueDate: fields[4] as DateTime?,
      isCompleted: fields[5] as bool,
      createdAt: fields[6] as DateTime?,
      order: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.note)
      ..writeByte(3)
      ..write(obj.quadrant)
      ..writeByte(4)
      ..write(obj.dueDate)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.order);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuadrantTypeAdapter extends TypeAdapter<QuadrantType> {
  @override
  final int typeId = 1;

  @override
  QuadrantType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QuadrantType.importantUrgent;
      case 1:
        return QuadrantType.importantNotUrgent;
      case 2:
        return QuadrantType.notImportantUrgent;
      case 3:
        return QuadrantType.notImportantNotUrgent;
      default:
        return QuadrantType.importantUrgent;
    }
  }

  @override
  void write(BinaryWriter writer, QuadrantType obj) {
    switch (obj) {
      case QuadrantType.importantUrgent:
        writer.writeByte(0);
        break;
      case QuadrantType.importantNotUrgent:
        writer.writeByte(1);
        break;
      case QuadrantType.notImportantUrgent:
        writer.writeByte(2);
        break;
      case QuadrantType.notImportantNotUrgent:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuadrantTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
