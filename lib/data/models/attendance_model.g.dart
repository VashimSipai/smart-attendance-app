// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceModel _$AttendanceModelFromJson(Map<String, dynamic> json) =>
    _AttendanceModel(
      studentUid: json['studentUid'] as String,
      sessionId: json['sessionId'] as String,
      timestamp: _timestampFromJson(json['timestamp']),
      deviceId: json['deviceId'] as String?,
      location: json['location'] as String?,
    );

Map<String, dynamic> _$AttendanceModelToJson(_AttendanceModel instance) =>
    <String, dynamic>{
      'studentUid': instance.studentUid,
      'sessionId': instance.sessionId,
      'timestamp': _timestampToJson(instance.timestamp),
      'deviceId': instance.deviceId,
      'location': instance.location,
    };
