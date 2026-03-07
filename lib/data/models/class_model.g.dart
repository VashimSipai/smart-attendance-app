// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClassModel _$ClassModelFromJson(Map<String, dynamic> json) => _ClassModel(
  id: json['id'] as String,
  programId: json['programId'] as String,
  year: json['year'] as String,
  section: json['section'] as String,
  semester: json['semester'] as String,
);

Map<String, dynamic> _$ClassModelToJson(_ClassModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'programId': instance.programId,
      'year': instance.year,
      'section': instance.section,
      'semester': instance.semester,
    };
