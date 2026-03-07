import 'package:freezed_annotation/freezed_annotation.dart';

part 'faculty_assignment_model.freezed.dart';
part 'faculty_assignment_model.g.dart';

@freezed
abstract class FacultyAssignmentModel with _$FacultyAssignmentModel {
  const factory FacultyAssignmentModel({
    required String id,
    required String collegeId,
    required String facultyId,
    required String classId,
    required String subjectId,
  }) = _FacultyAssignmentModel;

  factory FacultyAssignmentModel.fromJson(Map<String, dynamic> json) =>
      _$FacultyAssignmentModelFromJson(json);
}
