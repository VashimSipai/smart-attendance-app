// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'faculty_assignment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FacultyAssignmentModel {

 String get id; String get collegeId; String get facultyId; String get classId; String get subjectId;
/// Create a copy of FacultyAssignmentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FacultyAssignmentModelCopyWith<FacultyAssignmentModel> get copyWith => _$FacultyAssignmentModelCopyWithImpl<FacultyAssignmentModel>(this as FacultyAssignmentModel, _$identity);

  /// Serializes this FacultyAssignmentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FacultyAssignmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.collegeId, collegeId) || other.collegeId == collegeId)&&(identical(other.facultyId, facultyId) || other.facultyId == facultyId)&&(identical(other.classId, classId) || other.classId == classId)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,collegeId,facultyId,classId,subjectId);

@override
String toString() {
  return 'FacultyAssignmentModel(id: $id, collegeId: $collegeId, facultyId: $facultyId, classId: $classId, subjectId: $subjectId)';
}


}

/// @nodoc
abstract mixin class $FacultyAssignmentModelCopyWith<$Res>  {
  factory $FacultyAssignmentModelCopyWith(FacultyAssignmentModel value, $Res Function(FacultyAssignmentModel) _then) = _$FacultyAssignmentModelCopyWithImpl;
@useResult
$Res call({
 String id, String collegeId, String facultyId, String classId, String subjectId
});




}
/// @nodoc
class _$FacultyAssignmentModelCopyWithImpl<$Res>
    implements $FacultyAssignmentModelCopyWith<$Res> {
  _$FacultyAssignmentModelCopyWithImpl(this._self, this._then);

  final FacultyAssignmentModel _self;
  final $Res Function(FacultyAssignmentModel) _then;

/// Create a copy of FacultyAssignmentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? collegeId = null,Object? facultyId = null,Object? classId = null,Object? subjectId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,collegeId: null == collegeId ? _self.collegeId : collegeId // ignore: cast_nullable_to_non_nullable
as String,facultyId: null == facultyId ? _self.facultyId : facultyId // ignore: cast_nullable_to_non_nullable
as String,classId: null == classId ? _self.classId : classId // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FacultyAssignmentModel].
extension FacultyAssignmentModelPatterns on FacultyAssignmentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FacultyAssignmentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FacultyAssignmentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FacultyAssignmentModel value)  $default,){
final _that = this;
switch (_that) {
case _FacultyAssignmentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FacultyAssignmentModel value)?  $default,){
final _that = this;
switch (_that) {
case _FacultyAssignmentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String collegeId,  String facultyId,  String classId,  String subjectId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FacultyAssignmentModel() when $default != null:
return $default(_that.id,_that.collegeId,_that.facultyId,_that.classId,_that.subjectId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String collegeId,  String facultyId,  String classId,  String subjectId)  $default,) {final _that = this;
switch (_that) {
case _FacultyAssignmentModel():
return $default(_that.id,_that.collegeId,_that.facultyId,_that.classId,_that.subjectId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String collegeId,  String facultyId,  String classId,  String subjectId)?  $default,) {final _that = this;
switch (_that) {
case _FacultyAssignmentModel() when $default != null:
return $default(_that.id,_that.collegeId,_that.facultyId,_that.classId,_that.subjectId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FacultyAssignmentModel implements FacultyAssignmentModel {
  const _FacultyAssignmentModel({required this.id, required this.collegeId, required this.facultyId, required this.classId, required this.subjectId});
  factory _FacultyAssignmentModel.fromJson(Map<String, dynamic> json) => _$FacultyAssignmentModelFromJson(json);

@override final  String id;
@override final  String collegeId;
@override final  String facultyId;
@override final  String classId;
@override final  String subjectId;

/// Create a copy of FacultyAssignmentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FacultyAssignmentModelCopyWith<_FacultyAssignmentModel> get copyWith => __$FacultyAssignmentModelCopyWithImpl<_FacultyAssignmentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FacultyAssignmentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FacultyAssignmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.collegeId, collegeId) || other.collegeId == collegeId)&&(identical(other.facultyId, facultyId) || other.facultyId == facultyId)&&(identical(other.classId, classId) || other.classId == classId)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,collegeId,facultyId,classId,subjectId);

@override
String toString() {
  return 'FacultyAssignmentModel(id: $id, collegeId: $collegeId, facultyId: $facultyId, classId: $classId, subjectId: $subjectId)';
}


}

/// @nodoc
abstract mixin class _$FacultyAssignmentModelCopyWith<$Res> implements $FacultyAssignmentModelCopyWith<$Res> {
  factory _$FacultyAssignmentModelCopyWith(_FacultyAssignmentModel value, $Res Function(_FacultyAssignmentModel) _then) = __$FacultyAssignmentModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String collegeId, String facultyId, String classId, String subjectId
});




}
/// @nodoc
class __$FacultyAssignmentModelCopyWithImpl<$Res>
    implements _$FacultyAssignmentModelCopyWith<$Res> {
  __$FacultyAssignmentModelCopyWithImpl(this._self, this._then);

  final _FacultyAssignmentModel _self;
  final $Res Function(_FacultyAssignmentModel) _then;

/// Create a copy of FacultyAssignmentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? collegeId = null,Object? facultyId = null,Object? classId = null,Object? subjectId = null,}) {
  return _then(_FacultyAssignmentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,collegeId: null == collegeId ? _self.collegeId : collegeId // ignore: cast_nullable_to_non_nullable
as String,facultyId: null == facultyId ? _self.facultyId : facultyId // ignore: cast_nullable_to_non_nullable
as String,classId: null == classId ? _self.classId : classId // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
