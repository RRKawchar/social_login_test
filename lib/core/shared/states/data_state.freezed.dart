// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DataState<T> {

 Status get status; T? get data; String get message;
/// Create a copy of DataState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DataStateCopyWith<T, DataState<T>> get copyWith => _$DataStateCopyWithImpl<T, DataState<T>>(this as DataState<T>, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DataState<T>&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(data),message);

@override
String toString() {
  return 'DataState<$T>(status: $status, data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class $DataStateCopyWith<T,$Res>  {
  factory $DataStateCopyWith(DataState<T> value, $Res Function(DataState<T>) _then) = _$DataStateCopyWithImpl;
@useResult
$Res call({
 Status status, T? data, String message
});




}
/// @nodoc
class _$DataStateCopyWithImpl<T,$Res>
    implements $DataStateCopyWith<T, $Res> {
  _$DataStateCopyWithImpl(this._self, this._then);

  final DataState<T> _self;
  final $Res Function(DataState<T>) _then;

/// Create a copy of DataState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? data = freezed,Object? message = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T?,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DataState].
extension DataStatePatterns<T> on DataState<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DataState<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DataState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DataState<T> value)  $default,){
final _that = this;
switch (_that) {
case _DataState():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DataState<T> value)?  $default,){
final _that = this;
switch (_that) {
case _DataState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Status status,  T? data,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DataState() when $default != null:
return $default(_that.status,_that.data,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Status status,  T? data,  String message)  $default,) {final _that = this;
switch (_that) {
case _DataState():
return $default(_that.status,_that.data,_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Status status,  T? data,  String message)?  $default,) {final _that = this;
switch (_that) {
case _DataState() when $default != null:
return $default(_that.status,_that.data,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _DataState<T> implements DataState<T> {
  const _DataState({this.status = Status.initial, this.data, this.message = ''});
  

@override@JsonKey() final  Status status;
@override final  T? data;
@override@JsonKey() final  String message;

/// Create a copy of DataState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DataStateCopyWith<T, _DataState<T>> get copyWith => __$DataStateCopyWithImpl<T, _DataState<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DataState<T>&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(data),message);

@override
String toString() {
  return 'DataState<$T>(status: $status, data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class _$DataStateCopyWith<T,$Res> implements $DataStateCopyWith<T, $Res> {
  factory _$DataStateCopyWith(_DataState<T> value, $Res Function(_DataState<T>) _then) = __$DataStateCopyWithImpl;
@override @useResult
$Res call({
 Status status, T? data, String message
});




}
/// @nodoc
class __$DataStateCopyWithImpl<T,$Res>
    implements _$DataStateCopyWith<T, $Res> {
  __$DataStateCopyWithImpl(this._self, this._then);

  final _DataState<T> _self;
  final $Res Function(_DataState<T>) _then;

/// Create a copy of DataState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? data = freezed,Object? message = null,}) {
  return _then(_DataState<T>(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T?,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
