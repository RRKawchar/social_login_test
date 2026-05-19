import 'package:dartz/dartz.dart';

import '../../../../core/network/errors/network_exception.dart';
import '../../../../core/network/graphql/graphql_client.dart';
import '../../../../core/network/token_provider.dart';
import '../../../../core/shared/usecases/usecase.dart';
import '../../domain/entities/pre_login_result.dart';
import '../../domain/entities/social_auth_url.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/social_auth_url_query_input.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource, this._tokenProvider);

  final AuthRemoteDataSource _remoteDataSource;
  final TokenProvider _tokenProvider;

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

      final result = response.toEntity();
      await _tokenProvider.setAccessToken(result.accessToken);

      return Right(result);
    } on NetworkException catch (e) {
      return Left(_mapNetworkException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SocialAuthUrl>> getSocialAuthenticationUrl({
    required Map<String,dynamic> variable,
  }) async {
    try {
      final response = await _remoteDataSource.getSocialAuthenticationUrl(
        variable: variable,
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
