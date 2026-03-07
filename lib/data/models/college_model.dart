import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'college_model.freezed.dart';
part 'college_model.g.dart';

@freezed
abstract class CollegeModel with _$CollegeModel {
  const factory CollegeModel({
    required String id,
    required String name,
    required String address,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? createdAt,
  }) = _CollegeModel;

  factory CollegeModel.fromJson(Map<String, dynamic> json) =>
      _$CollegeModelFromJson(json);
}

DateTime? _timestampFromJson(dynamic value) {
  if (value is Timestamp) {
    return value.toDate();
  } else if (value is String) {
    return DateTime.parse(value);
  } else if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }
  return null;
}

dynamic _timestampToJson(DateTime? value) {
  if (value == null) return null;
  return Timestamp.fromDate(value);
}
