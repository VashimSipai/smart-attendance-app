// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timetable_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimetableModel {

 String get id; String get collegeId; String get classId; String get day; String get startTime; String get endTime; String get subjectId; String get facultyId;
/// Create a copy of TimetableModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimetableModelCopyWith<TimetableModel> get copyWith => _$TimetableModelCopyWithImpl<TimetableModel>(this as TimetableModel, _$identity);

  /// Serializes this TimetableModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimetableModel&&(identical(other.id, id) || other.id == id)&&(identical(other.collegeId, collegeId) || other.collegeId == collegeId)&&(identical(other.classId, classId) || other.classId == classId)&&(identical(other.day, day) || other.day == day)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.facultyId, facultyId) || other.facultyId == facultyId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,collegeId,classId,day,startTime,endTime,subjectId,facultyId);

@override
String toString() {
  return 'TimetableModel(id: $id, collegeId: $collegeId, classId: $classId, day: $day, startTime: $startTime, endTime: $endTime, subjectId: $subjectId, facultyId: $facultyId)';
}


}

/// @nodoc
abstract mixin class $TimetableModelCopyWith<$Res>  {
  factory $TimetableModelCopyWith(TimetableModel value, $Res Function(TimetableModel) _then) = _$TimetableModelCopyWithImpl;
@useResult
$Res call({
 String id, String collegeId, String classId, String day, String startTime, String endTime, String subjectId, String facultyId
});




}
/// @nodoc
class _$TimetableModelCopyWithImpl<$Res>
    implements $TimetableModelCopyWith<$Res> {
  _$TimetableModelCopyWithImpl(this._self, this._then);

  final TimetableModel _self;
  final $Res Function(TimetableModel) _then;

/// Create a copy of TimetableModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? collegeId = null,Object? classId = null,Object? day = null,Object? startTime = null,Object? endTime = null,Object? subjectId = null,Object? facultyId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,collegeId: null == collegeId ? _self.collegeId : collegeId // ignore: cast_nullable_to_non_nullable
as String,classId: null == classId ? _self.classId : classId // ignore: cast_nullable_to_non_nullable
as String,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,facultyId: null == facultyId ? _self.facultyId : facultyId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TimetableModel].
extension TimetableModelPatterns on TimetableModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimetableModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimetableModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimetableModel value)  $default,){
final _that = this;
switch (_that) {
case _TimetableModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimetableModel value)?  $default,){
final _that = this;
switch (_that) {
case _TimetableModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String collegeId,  String classId,  String day,  String startTime,  String endTime,  String subjectId,  String facultyId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimetableModel() when $default != null:
return $default(_that.id,_that.collegeId,_that.classId,_that.day,_that.startTime,_that.endTime,_that.subjectId,_that.facultyId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String collegeId,  String classId,  String day,  String startTime,  String endTime,  String subjectId,  String facultyId)  $default,) {final _that = this;
switch (_that) {
case _TimetableModel():
return $default(_that.id,_that.collegeId,_that.classId,_that.day,_that.startTime,_that.endTime,_that.subjectId,_that.facultyId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String collegeId,  String classId,  String day,  String startTime,  String endTime,  String subjectId,  String facultyId)?  $default,) {final _that = this;
switch (_that) {
case _TimetableModel() when $default != null:
return $default(_that.id,_that.collegeId,_that.classId,_that.day,_that.startTime,_that.endTime,_that.subjectId,_that.facultyId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimetableModel implements TimetableModel {
  const _TimetableModel({required this.id, required this.collegeId, required this.classId, required this.day, required this.startTime, required this.endTime, required this.subjectId, required this.facultyId});
  factory _TimetableModel.fromJson(Map<String, dynamic> json) => _$TimetableModelFromJson(json);

@override final  String id;
@override final  String collegeId;
@override final  String classId;
@override final  String day;
@override final  String startTime;
@override final  String endTime;
@override final  String subjectId;
@override final  String facultyId;

/// Create a copy of TimetableModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimetableModelCopyWith<_TimetableModel> get copyWith => __$TimetableModelCopyWithImpl<_TimetableModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimetableModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimetableModel&&(identical(other.id, id) || other.id == id)&&(identical(other.collegeId, collegeId) || other.collegeId == collegeId)&&(identical(other.classId, classId) || other.classId == classId)&&(identical(other.day, day) || other.day == day)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.facultyId, facultyId) || other.facultyId == facultyId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,collegeId,classId,day,startTime,endTime,subjectId,facultyId);

@override
String toString() {
  return 'TimetableModel(id: $id, collegeId: $collegeId, classId: $classId, day: $day, startTime: $startTime, endTime: $endTime, subjectId: $subjectId, facultyId: $facultyId)';
}


}

/// @nodoc
abstract mixin class _$TimetableModelCopyWith<$Res> implements $TimetableModelCopyWith<$Res> {
  factory _$TimetableModelCopyWith(_TimetableModel value, $Res Function(_TimetableModel) _then) = __$TimetableModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String collegeId, String classId, String day, String startTime, String endTime, String subjectId, String facultyId
});




}
/// @nodoc
class __$TimetableModelCopyWithImpl<$Res>
    implements _$TimetableModelCopyWith<$Res> {
  __$TimetableModelCopyWithImpl(this._self, this._then);

  final _TimetableModel _self;
  final $Res Function(_TimetableModel) _then;

/// Create a copy of TimetableModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? collegeId = null,Object? classId = null,Object? day = null,Object? startTime = null,Object? endTime = null,Object? subjectId = null,Object? facultyId = null,}) {
  return _then(_TimetableModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,collegeId: null == collegeId ? _self.collegeId : collegeId // ignore: cast_nullable_to_non_nullable
as String,classId: null == classId ? _self.classId : classId // ignore: cast_nullable_to_non_nullable
as String,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,facultyId: null == facultyId ? _self.facultyId : facultyId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
