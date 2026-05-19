import 'package:dartz/dartz.dart';

import '../../../../core/shared/usecases/usecase.dart';
import '../entities/pre_login_result.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, PreLoginResult>> preLogin({
    required String appName,
    required String token,
  });
}
