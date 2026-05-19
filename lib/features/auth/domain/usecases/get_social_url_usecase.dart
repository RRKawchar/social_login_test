import 'package:dartz/dartz.dart';

import '../../../../core/shared/usecases/usecase.dart';
import '../entities/social_auth_url.dart';
import '../repositories/auth_repository.dart';

class GetSocialUrlParams {
  const GetSocialUrlParams({
    required this.accessToken,
    required this.variables,
  });

  /// Pre-login access token (login page only — not the app session token).
  final String accessToken;

  /// GraphQL variables, e.g. `{ "queryData": { ... } }`.
  final Map<String, dynamic> variables;
}

class GetSocialUrlUseCase implements UseCase<SocialAuthUrl, GetSocialUrlParams> {
  GetSocialUrlUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, SocialAuthUrl>> call(GetSocialUrlParams params) {
    return _repository.getSocialAuthenticationUrl(
      accessToken: params.accessToken,
      variables: params.variables,
    );
  }
}
