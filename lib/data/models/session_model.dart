import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'session_model.freezed.dart';
part 'session_model.g.dart';

@freezed
abstract class SessionModel with _$SessionModel {
  const factory SessionModel({
    required String id,
    required String collegeId,
    required String timetableId,
    required String facultyId,
    required String subjectId,
    required String classId,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime startTime,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime expiryTime,
    required String qrToken,
    required bool isActive,
  }) = _SessionModel;

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);
}

DateTime _timestampFromJson(dynamic value) {
  if (value is Timestamp) {
    return value.toDate();
  } else if (value is String) {
    return DateTime.parse(value);
  } else if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }
  return DateTime.now(); // Fallback
}

dynamic _timestampToJson(DateTime value) {
  return Timestamp.fromDate(value);
}
