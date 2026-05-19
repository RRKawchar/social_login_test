import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/status.dart';
import '../../../../core/shared/states/data_state.dart';
import '../../domain/entities/pre_login_result.dart';
import '../../domain/usecases/pre_login_usecase.dart';

class PreLoginCubit extends Cubit<DataState<PreLoginResult>> {
  PreLoginCubit(this._preLoginUseCase) : super(const DataState());

  final PreLoginUseCase _preLoginUseCase;

  Future<void> preLogin([PreLoginParams? params]) async {
    if (state.status == Status.loading || state.status == Status.success) {
      return;
    }

    emit(state.copyWith(status: Status.loading, message: ''));

    final result = await _preLoginUseCase(params ?? PreLoginParams.defaults());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          message: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          status: Status.success,
          data: data,
          message: data.message,
        ),
      ),
    );
  }
}
