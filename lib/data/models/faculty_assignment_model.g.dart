// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faculty_assignment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FacultyAssignmentModel _$FacultyAssignmentModelFromJson(
  Map<String, dynamic> json,
) => _FacultyAssignmentModel(
  id: json['id'] as String,
  collegeId: json['collegeId'] as String,
  facultyId: json['facultyId'] as String,
  classId: json['classId'] as String,
  subjectId: json['subjectId'] as String,
);

Map<String, dynamic> _$FacultyAssignmentModelToJson(
  _FacultyAssignmentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'collegeId': instance.collegeId,
  'facultyId': instance.facultyId,
  'classId': instance.classId,
  'subjectId': instance.subjectId,
};
