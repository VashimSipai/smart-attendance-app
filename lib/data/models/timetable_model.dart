import 'package:freezed_annotation/freezed_annotation.dart';

part 'timetable_model.freezed.dart';
part 'timetable_model.g.dart';

@freezed
abstract class TimetableModel with _$TimetableModel {
  const factory TimetableModel({
    required String id,
    required String collegeId,
    required String classId,
    required String day,
    required String startTime,
    required String endTime,
    required String subjectId,
    required String facultyId,
  }) = _TimetableModel;

  factory TimetableModel.fromJson(Map<String, dynamic> json) =>
      _$TimetableModelFromJson(json);
}
