// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'college_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CollegeModel {

 String get id; String get name; String get address;@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime? get createdAt;
/// Create a copy of CollegeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollegeModelCopyWith<CollegeModel> get copyWith => _$CollegeModelCopyWithImpl<CollegeModel>(this as CollegeModel, _$identity);

  /// Serializes this CollegeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollegeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,createdAt);

@override
String toString() {
  return 'CollegeModel(id: $id, name: $name, address: $address, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CollegeModelCopyWith<$Res>  {
  factory $CollegeModelCopyWith(CollegeModel value, $Res Function(CollegeModel) _then) = _$CollegeModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String address,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime? createdAt
});




}
/// @nodoc
class _$CollegeModelCopyWithImpl<$Res>
    implements $CollegeModelCopyWith<$Res> {
  _$CollegeModelCopyWithImpl(this._self, this._then);

  final CollegeModel _self;
  final $Res Function(CollegeModel) _then;

/// Create a copy of CollegeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CollegeModel].
extension CollegeModelPatterns on CollegeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CollegeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CollegeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CollegeModel value)  $default,){
final _that = this;
switch (_that) {
case _CollegeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CollegeModel value)?  $default,){
final _that = this;
switch (_that) {
case _CollegeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String address, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CollegeModel() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String address, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _CollegeModel():
return $default(_that.id,_that.name,_that.address,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String address, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CollegeModel() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CollegeModel implements CollegeModel {
  const _CollegeModel({required this.id, required this.name, required this.address, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) this.createdAt});
  factory _CollegeModel.fromJson(Map<String, dynamic> json) => _$CollegeModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String address;
@override@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) final  DateTime? createdAt;

/// Create a copy of CollegeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollegeModelCopyWith<_CollegeModel> get copyWith => __$CollegeModelCopyWithImpl<_CollegeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CollegeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollegeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,createdAt);

@override
String toString() {
  return 'CollegeModel(id: $id, name: $name, address: $address, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CollegeModelCopyWith<$Res> implements $CollegeModelCopyWith<$Res> {
  factory _$CollegeModelCopyWith(_CollegeModel value, $Res Function(_CollegeModel) _then) = __$CollegeModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String address,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime? createdAt
});




}
/// @nodoc
class __$CollegeModelCopyWithImpl<$Res>
    implements _$CollegeModelCopyWith<$Res> {
  __$CollegeModelCopyWithImpl(this._self, this._then);

  final _CollegeModel _self;
  final $Res Function(_CollegeModel) _then;

/// Create a copy of CollegeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = null,Object? createdAt = freezed,}) {
  return _then(_CollegeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
