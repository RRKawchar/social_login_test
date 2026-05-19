import 'package:dartz/dartz.dart';

import '../../../../core/shared/usecases/usecase.dart';
import '../entities/pre_login_result.dart';
import '../entities/social_auth_url.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, PreLoginResult>> preLogin({
    required String appName,
    required String token,
  });

  Future<Either<Failure, SocialAuthUrl>> getSocialAuthenticationUrl({
    required String accessToken,
    required Map<String, dynamic> variables,
  });
}
