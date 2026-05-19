import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/status.dart';
import '../../../../core/shared/states/data_state.dart';
import '../../domain/entities/social_auth_url.dart';
import '../../domain/usecases/get_social_url_usecase.dart';

class GetSocialUrlCubit extends Cubit<DataState<SocialAuthUrl>> {
  GetSocialUrlCubit(this._getSocialUrlUseCase) : super(const DataState());

  final GetSocialUrlUseCase _getSocialUrlUseCase;

  Future<void> fetchGoogleUrl({
    required String accessToken,
    required Map<String, dynamic> variables,
  }) async {
    if (state.status == Status.loading) return;

    emit(state.copyWith(status: Status.loading, message: ''));

    final result = await _getSocialUrlUseCase(
      GetSocialUrlParams(
        accessToken: accessToken,
        variables: variables,
      ),
    );

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
          message: 'OAuth URL ready',
        ),
      ),
    );
  }
}
