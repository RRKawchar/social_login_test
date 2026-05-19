import 'package:dartz/dartz.dart';

import '../../../../core/network/errors/network_exception.dart';
import '../../../../core/network/graphql/graphql_client.dart';
import '../../../../core/shared/usecases/usecase.dart';
import '../../domain/entities/pre_login_result.dart';
import '../../domain/entities/social_auth_url.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, PreLoginResult>> preLogin({
    required String appName,
    required String token,
  }) async {
    try {
      final response = await _remoteDataSource.appLogin(
        appName: appName,
        token: token,
      );

      if (response.accessToken.isEmpty) {
        return const Left(ServerFailure('Access token missing in response'));
      }

      return Right(response.toEntity());
    } on NetworkException catch (e) {
      return Left(_mapNetworkException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SocialAuthUrl>> getSocialAuthenticationUrl({
    required String accessToken,
    required Map<String, dynamic> variables,
  }) async {
    try {
      final response = await _remoteDataSource.getSocialAuthenticationUrl(
        accessToken: accessToken,
        variables: variables,
      );

      if (response.url.isEmpty) {
        return const Left(ServerFailure('OAuth URL missing in response'));
      }

      return Right(response.toEntity());
    } on GraphQLResponseException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on NetworkException catch (e) {
      return Left(_mapNetworkException(e));
    } catch (e) {

      print("check dkjfkdfjkdfkdfkjdf ----- $e");
      return Left(ServerFailure(e.toString()));
    }
  }

  Failure _mapNetworkException(NetworkException exception) {
    return switch (exception) {
      ConnectionNetworkException() => const NetworkFailure(),
      TimeoutNetworkException() => const ServerFailure('Request timed out'),
      CancelledNetworkException() => const ServerFailure('Request cancelled'),
      HttpNetworkException(:final statusCode, :final message) =>
        ServerFailure('$message${statusCode == null ? '' : ' ($statusCode)'}'),
      BadCertificateNetworkException() => const ServerFailure('Bad certificate'),
      UnknownNetworkException() => const UnexpectedFailure(),
    };
  }
}
