import 'package:dartz/dartz.dart';

import '../../../../core/config/gain_auth_config.dart';
import '../../../../core/shared/usecases/usecase.dart';
import '../entities/pre_login_result.dart';
import '../repositories/auth_repository.dart';

class PreLoginParams {
  const PreLoginParams({
    required this.appName,
    required this.token,
  });

  final String appName;
  final String token;

  factory PreLoginParams.defaults() => const PreLoginParams(
        appName: GainAuthConfig.appName,
        token: GainAuthConfig.appLoginToken,
      );
}

class PreLoginUseCase implements UseCase<PreLoginResult, PreLoginParams> {
  PreLoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, PreLoginResult>> call(PreLoginParams params) {
    return _repository.preLogin(
      appName: params.appName,
      token: params.token,
    );
  }
}
