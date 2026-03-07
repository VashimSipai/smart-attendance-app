// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionModel {

 String get id; String get collegeId; String get timetableId; String get facultyId; String get subjectId; String get classId;@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime get startTime;@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime get expiryTime; String get qrToken; bool get isActive;
/// Create a copy of SessionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionModelCopyWith<SessionModel> get copyWith => _$SessionModelCopyWithImpl<SessionModel>(this as SessionModel, _$identity);

  /// Serializes this SessionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.collegeId, collegeId) || other.collegeId == collegeId)&&(identical(other.timetableId, timetableId) || other.timetableId == timetableId)&&(identical(other.facultyId, facultyId) || other.facultyId == facultyId)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.classId, classId) || other.classId == classId)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.expiryTime, expiryTime) || other.expiryTime == expiryTime)&&(identical(other.qrToken, qrToken) || other.qrToken == qrToken)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,collegeId,timetableId,facultyId,subjectId,classId,startTime,expiryTime,qrToken,isActive);

@override
String toString() {
  return 'SessionModel(id: $id, collegeId: $collegeId, timetableId: $timetableId, facultyId: $facultyId, subjectId: $subjectId, classId: $classId, startTime: $startTime, expiryTime: $expiryTime, qrToken: $qrToken, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $SessionModelCopyWith<$Res>  {
  factory $SessionModelCopyWith(SessionModel value, $Res Function(SessionModel) _then) = _$SessionModelCopyWithImpl;
@useResult
$Res call({
 String id, String collegeId, String timetableId, String facultyId, String subjectId, String classId,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime startTime,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime expiryTime, String qrToken, bool isActive
});




}
/// @nodoc
class _$SessionModelCopyWithImpl<$Res>
    implements $SessionModelCopyWith<$Res> {
  _$SessionModelCopyWithImpl(this._self, this._then);

  final SessionModel _self;
  final $Res Function(SessionModel) _then;

/// Create a copy of SessionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? collegeId = null,Object? timetableId = null,Object? facultyId = null,Object? subjectId = null,Object? classId = null,Object? startTime = null,Object? expiryTime = null,Object? qrToken = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,collegeId: null == collegeId ? _self.collegeId : collegeId // ignore: cast_nullable_to_non_nullable
as String,timetableId: null == timetableId ? _self.timetableId : timetableId // ignore: cast_nullable_to_non_nullable
as String,facultyId: null == facultyId ? _self.facultyId : facultyId // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,classId: null == classId ? _self.classId : classId // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,expiryTime: null == expiryTime ? _self.expiryTime : expiryTime // ignore: cast_nullable_to_non_nullable
as DateTime,qrToken: null == qrToken ? _self.qrToken : qrToken // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionModel].
extension SessionModelPatterns on SessionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionModel value)  $default,){
final _that = this;
switch (_that) {
case _SessionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionModel value)?  $default,){
final _that = this;
switch (_that) {
case _SessionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String collegeId,  String timetableId,  String facultyId,  String subjectId,  String classId, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  DateTime startTime, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  DateTime expiryTime,  String qrToken,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionModel() when $default != null:
return $default(_that.id,_that.collegeId,_that.timetableId,_that.facultyId,_that.subjectId,_that.classId,_that.startTime,_that.expiryTime,_that.qrToken,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String collegeId,  String timetableId,  String facultyId,  String subjectId,  String classId, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  DateTime startTime, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  DateTime expiryTime,  String qrToken,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _SessionModel():
return $default(_that.id,_that.collegeId,_that.timetableId,_that.facultyId,_that.subjectId,_that.classId,_that.startTime,_that.expiryTime,_that.qrToken,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String collegeId,  String timetableId,  String facultyId,  String subjectId,  String classId, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  DateTime startTime, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  DateTime expiryTime,  String qrToken,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _SessionModel() when $default != null:
return $default(_that.id,_that.collegeId,_that.timetableId,_that.facultyId,_that.subjectId,_that.classId,_that.startTime,_that.expiryTime,_that.qrToken,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionModel implements SessionModel {
  const _SessionModel({required this.id, required this.collegeId, required this.timetableId, required this.facultyId, required this.subjectId, required this.classId, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) required this.startTime, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) required this.expiryTime, required this.qrToken, required this.isActive});
  factory _SessionModel.fromJson(Map<String, dynamic> json) => _$SessionModelFromJson(json);

@override final  String id;
@override final  String collegeId;
@override final  String timetableId;
@override final  String facultyId;
@override final  String subjectId;
@override final  String classId;
@override@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) final  DateTime startTime;
@override@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) final  DateTime expiryTime;
@override final  String qrToken;
@override final  bool isActive;

/// Create a copy of SessionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionModelCopyWith<_SessionModel> get copyWith => __$SessionModelCopyWithImpl<_SessionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.collegeId, collegeId) || other.collegeId == collegeId)&&(identical(other.timetableId, timetableId) || other.timetableId == timetableId)&&(identical(other.facultyId, facultyId) || other.facultyId == facultyId)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.classId, classId) || other.classId == classId)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.expiryTime, expiryTime) || other.expiryTime == expiryTime)&&(identical(other.qrToken, qrToken) || other.qrToken == qrToken)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,collegeId,timetableId,facultyId,subjectId,classId,startTime,expiryTime,qrToken,isActive);

@override
String toString() {
  return 'SessionModel(id: $id, collegeId: $collegeId, timetableId: $timetableId, facultyId: $facultyId, subjectId: $subjectId, classId: $classId, startTime: $startTime, expiryTime: $expiryTime, qrToken: $qrToken, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$SessionModelCopyWith<$Res> implements $SessionModelCopyWith<$Res> {
  factory _$SessionModelCopyWith(_SessionModel value, $Res Function(_SessionModel) _then) = __$SessionModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String collegeId, String timetableId, String facultyId, String subjectId, String classId,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime startTime,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime expiryTime, String qrToken, bool isActive
});




}
/// @nodoc
class __$SessionModelCopyWithImpl<$Res>
    implements _$SessionModelCopyWith<$Res> {
  __$SessionModelCopyWithImpl(this._self, this._then);

  final _SessionModel _self;
  final $Res Function(_SessionModel) _then;

/// Create a copy of SessionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? collegeId = null,Object? timetableId = null,Object? facultyId = null,Object? subjectId = null,Object? classId = null,Object? startTime = null,Object? expiryTime = null,Object? qrToken = null,Object? isActive = null,}) {
  return _then(_SessionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,collegeId: null == collegeId ? _self.collegeId : collegeId // ignore: cast_nullable_to_non_nullable
as String,timetableId: null == timetableId ? _self.timetableId : timetableId // ignore: cast_nullable_to_non_nullable
as String,facultyId: null == facultyId ? _self.facultyId : facultyId // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,classId: null == classId ? _self.classId : classId // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,expiryTime: null == expiryTime ? _self.expiryTime : expiryTime // ignore: cast_nullable_to_non_nullable
as DateTime,qrToken: null == qrToken ? _self.qrToken : qrToken // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
