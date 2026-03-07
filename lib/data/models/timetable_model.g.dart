// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimetableModel _$TimetableModelFromJson(Map<String, dynamic> json) =>
    _TimetableModel(
      id: json['id'] as String,
      collegeId: json['collegeId'] as String,
      classId: json['classId'] as String,
      day: json['day'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      subjectId: json['subjectId'] as String,
      facultyId: json['facultyId'] as String,
    );

Map<String, dynamic> _$TimetableModelToJson(_TimetableModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'collegeId': instance.collegeId,
      'classId': instance.classId,
      'day': instance.day,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'subjectId': instance.subjectId,
      'facultyId': instance.facultyId,
    };
