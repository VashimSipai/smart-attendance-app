// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'college_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CollegeModel _$CollegeModelFromJson(Map<String, dynamic> json) =>
    _CollegeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      createdAt: _timestampFromJson(json['createdAt']),
    );

Map<String, dynamic> _$CollegeModelToJson(_CollegeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'createdAt': _timestampToJson(instance.createdAt),
    };
