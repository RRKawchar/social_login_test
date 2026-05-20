import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/status.dart';
import '../../../../core/shared/states/data_state.dart';
import '../../domain/entities/social_callback_entity.dart';
import '../../domain/usecases/social_callback_usecase.dart';

class SocialCallbackCubit extends Cubit<DataState<SocialCallbackEntity>> {
  SocialCallbackCubit(this._socialCallbackUsecase) : super(const DataState());

  final SocialCallbackUsecase _socialCallbackUsecase;

  Future<void> handleSocialCallBack({
    required String accessToken,
    required Map<String, dynamic> variables,
  }) async {
    if (state.status == Status.loading) return;

    emit(state.copyWith(status: Status.loading, message: ''));

    final result = await _socialCallbackUsecase(
      SocialCallbackParams(accessToken: accessToken, variables: variables),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(status: Status.failure, message: failure.message));
      },
      (data) {
        emit(
          state.copyWith(
            status: Status.success,
            data: data,
            message: 'Social Callback Success',
          ),
        );
      },
    );
  }
}
