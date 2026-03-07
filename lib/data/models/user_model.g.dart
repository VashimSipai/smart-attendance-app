// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  uid: json['uid'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  role: json['role'] as String,
  rollNumber: json['rollNumber'] as String?,
  profileCompleted: json['profileCompleted'] as bool? ?? false,
  collegeId: json['collegeId'] as String?,
  programId: json['programId'] as String?,
  classId: json['classId'] as String?,
  createdAt: _timestampFromJson(json['createdAt']),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'role': instance.role,
      'rollNumber': instance.rollNumber,
      'profileCompleted': instance.profileCompleted,
      'collegeId': instance.collegeId,
      'programId': instance.programId,
      'classId': instance.classId,
      'createdAt': _timestampToJson(instance.createdAt),
    };
