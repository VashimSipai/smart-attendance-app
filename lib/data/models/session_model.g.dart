// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionModel _$SessionModelFromJson(Map<String, dynamic> json) =>
    _SessionModel(
      id: json['id'] as String,
      collegeId: json['collegeId'] as String,
      timetableId: json['timetableId'] as String,
      facultyId: json['facultyId'] as String,
      subjectId: json['subjectId'] as String,
      classId: json['classId'] as String,
      startTime: _timestampFromJson(json['startTime']),
      expiryTime: _timestampFromJson(json['expiryTime']),
      qrToken: json['qrToken'] as String,
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$SessionModelToJson(_SessionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'collegeId': instance.collegeId,
      'timetableId': instance.timetableId,
      'facultyId': instance.facultyId,
      'subjectId': instance.subjectId,
      'classId': instance.classId,
      'startTime': _timestampToJson(instance.startTime),
      'expiryTime': _timestampToJson(instance.expiryTime),
      'qrToken': instance.qrToken,
      'isActive': instance.isActive,
    };
