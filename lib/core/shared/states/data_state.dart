import 'package:freezed_annotation/freezed_annotation.dart';
import '../../enums/status.dart';
part 'data_state.freezed.dart';

@freezed
sealed class DataState<T> with _$DataState<T> {
  const factory DataState({
    @Default(Status.initial) Status status,
    T? data,
    @Default('') String message,
  }) = _DataState<T>;
}