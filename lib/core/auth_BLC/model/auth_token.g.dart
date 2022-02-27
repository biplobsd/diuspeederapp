// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_token.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthTokenAdapter extends TypeAdapter<AuthToken> {
  @override
  final int typeId = 1;

  @override
  AuthToken read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthToken(
      token: fields[0] as String,
      privateToken: fields[1] as String,
      logintoken: fields[2] as String?,
      user: fields[3] as String,
      pass: fields[4] as String,
      autoGenKey: fields[5] as String,
      isSave: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AuthToken obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.token)
      ..writeByte(1)
      ..write(obj.privateToken)
      ..writeByte(2)
      ..write(obj.logintoken)
      ..writeByte(3)
      ..write(obj.user)
      ..writeByte(4)
      ..write(obj.pass)
      ..writeByte(5)
      ..write(obj.autoGenKey)
      ..writeByte(6)
      ..write(obj.isSave);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthTokenAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
