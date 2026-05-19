import 'package:dartz/dartz.dart';

import '../../../../core/config/gain_auth_config.dart';
import '../../../../core/shared/usecases/usecase.dart';
import '../entities/social_auth_url.dart';
import '../repositories/auth_repository.dart';

class GetSocialUrlUseCase implements UseCase<SocialAuthUrl, Map<String,dynamic>> {
  GetSocialUrlUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, SocialAuthUrl>> call(Map<String,dynamic> variable) {
    return _repository.getSocialAuthenticationUrl(
      variable: variable
    );
  }
}
