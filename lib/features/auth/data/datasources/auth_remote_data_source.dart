import 'package:dio/dio.dart';

import '../../../../core/config/gain_auth_config.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/graphql/graphql_client.dart';
import '../../../../core/network/graphql/graphql_queries.dart';
import '../models/pre_login_response_model.dart';
import '../models/social_auth_url_query_input.dart';
import '../models/social_auth_url_response_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<PreLoginResponseModel> appLogin({
    required String appName,
    required String token,
  });

  Future<SocialAuthUrlResponseModel> getSocialAuthenticationUrl({
    required Map<String,dynamic> variable,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._client, this._graphQL);

  final DioClient _client;
  final GraphQLDioClient _graphQL;

  static Options get _wafOptions => Options(
        headers: <String, String>{
          'x-waf-mobile-token': GainAuthConfig.wafMobileToken,
        },
      );

  @override
  Future<PreLoginResponseModel> appLogin({
    required String appName,
    required String token,
  }) async {
    final json = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.appLogin,
      data: <String, String>{
        'app_name': appName,
        'token': token,
      },
      options: _wafOptions,
    );

    return PreLoginResponseModel.fromJson(json);
  }

  @override
  Future<SocialAuthUrlResponseModel> getSocialAuthenticationUrl({
    required Map<String,dynamic> variable,
  }) async {
    final data = await _graphQL.query(
      graphqlQuery: GraphqlQueries.getSocialUrl,
      variables: <String, dynamic>{
        'queryData': variable,
      },
      operationName: 'GET_SOCIAL_AUTHENTICATION_URL',
      options: _wafOptions,
    );

    return SocialAuthUrlResponseModel.fromGraphQLData(data);
  }
}
