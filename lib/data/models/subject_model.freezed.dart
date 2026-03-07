// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subject_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubjectModel {

 String get id; String get name; String get programId;
/// Create a copy of SubjectModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubjectModelCopyWith<SubjectModel> get copyWith => _$SubjectModelCopyWithImpl<SubjectModel>(this as SubjectModel, _$identity);

  /// Serializes this SubjectModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubjectModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.programId, programId) || other.programId == programId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,programId);

@override
String toString() {
  return 'SubjectModel(id: $id, name: $name, programId: $programId)';
}


}

/// @nodoc
abstract mixin class $SubjectModelCopyWith<$Res>  {
  factory $SubjectModelCopyWith(SubjectModel value, $Res Function(SubjectModel) _then) = _$SubjectModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String programId
});




}
/// @nodoc
class _$SubjectModelCopyWithImpl<$Res>
    implements $SubjectModelCopyWith<$Res> {
  _$SubjectModelCopyWithImpl(this._self, this._then);

  final SubjectModel _self;
  final $Res Function(SubjectModel) _then;

/// Create a copy of SubjectModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? programId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SubjectModel].
extension SubjectModelPatterns on SubjectModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubjectModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubjectModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubjectModel value)  $default,){
final _that = this;
switch (_that) {
case _SubjectModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubjectModel value)?  $default,){
final _that = this;
switch (_that) {
case _SubjectModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String programId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubjectModel() when $default != null:
return $default(_that.id,_that.name,_that.programId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String programId)  $default,) {final _that = this;
switch (_that) {
case _SubjectModel():
return $default(_that.id,_that.name,_that.programId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String programId)?  $default,) {final _that = this;
switch (_that) {
case _SubjectModel() when $default != null:
return $default(_that.id,_that.name,_that.programId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubjectModel implements SubjectModel {
  const _SubjectModel({required this.id, required this.name, required this.programId});
  factory _SubjectModel.fromJson(Map<String, dynamic> json) => _$SubjectModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String programId;

/// Create a copy of SubjectModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubjectModelCopyWith<_SubjectModel> get copyWith => __$SubjectModelCopyWithImpl<_SubjectModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubjectModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubjectModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.programId, programId) || other.programId == programId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,programId);

@override
String toString() {
  return 'SubjectModel(id: $id, name: $name, programId: $programId)';
}


}

/// @nodoc
abstract mixin class _$SubjectModelCopyWith<$Res> implements $SubjectModelCopyWith<$Res> {
  factory _$SubjectModelCopyWith(_SubjectModel value, $Res Function(_SubjectModel) _then) = __$SubjectModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String programId
});




}
/// @nodoc
class __$SubjectModelCopyWithImpl<$Res>
    implements _$SubjectModelCopyWith<$Res> {
  __$SubjectModelCopyWithImpl(this._self, this._then);

  final _SubjectModel _self;
  final $Res Function(_SubjectModel) _then;

/// Create a copy of SubjectModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? programId = null,}) {
  return _then(_SubjectModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
