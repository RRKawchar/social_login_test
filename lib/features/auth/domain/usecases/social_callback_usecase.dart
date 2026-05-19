import 'package:dartz/dartz.dart';
import 'package:social_login_test/features/auth/domain/entities/social_callback_entity.dart';

import '../../../../core/shared/usecases/usecase.dart';
import '../entities/social_auth_url.dart';
import '../repositories/auth_repository.dart';

class SocialCallbackParams {
  const SocialCallbackParams({
    required this.accessToken,
    required this.variables,
  });

  /// Pre-login access token (login page only — not the app session token).
  final String accessToken;

  /// GraphQL variables, e.g. `{ "queryData": { ... } }`.
  final Map<String, dynamic> variables;
}

class SocialCallbackUsecase implements UseCase<SocialCallbackEntity, SocialCallbackParams> {
  SocialCallbackUsecase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, SocialCallbackEntity>> call(SocialCallbackParams params) {
    return _repository.manageSocialCallback(
      accessToken: params.accessToken,
      variables: params.variables,
    );
  }
}
