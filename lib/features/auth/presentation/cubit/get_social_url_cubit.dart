import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/status.dart';
import '../../../../core/shared/states/data_state.dart';
import '../../domain/entities/social_auth_url.dart';
import '../../domain/usecases/get_social_url_usecase.dart';

class GetSocialUrlCubit extends Cubit<DataState<SocialAuthUrl>> {
  GetSocialUrlCubit(this._getSocialUrlUseCase) : super(const DataState());

  final GetSocialUrlUseCase _getSocialUrlUseCase;

  Future<void> fetchGoogleUrl({required Map<String,dynamic> variable,}) async {
    if (state.status == Status.loading) return;

    emit(state.copyWith(status: Status.loading, message: ''));

    final result = await _getSocialUrlUseCase(variable);

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
