import 'package:dio/dio.dart';
import 'package:social_login_test/features/auth/data/models/social_callback_model.dart';
import 'package:social_login_test/features/auth/domain/entities/social_callback_entity.dart';

import '../../../../core/config/gain_auth_config.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/graphql/graphql_client.dart';
import '../../../../core/network/graphql/graphql_queries.dart';
import '../../../../core/network/interceptors/auth_interceptor.dart';
import '../models/pre_login_response_model.dart';
import '../models/social_auth_url_response_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<PreLoginResponseModel> appLogin({
    required String appName,
    required String token,
  });

  Future<SocialAuthUrlResponseModel> getSocialAuthenticationUrl({
    required String accessToken,
    required Map<String, dynamic> variables,
  });

  Future<SocialCallbackModel> manageSocialCallback({
    required String accessToken,
    required Map<String, dynamic> variables,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._client, this._graphQL);
  final DioClient _client;
  final GraphQLDioClient _graphQL;


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
      options: Options(
          headers: <String, String>{
            'x-waf-mobile-token': GainAuthConfig.wafMobileToken,
          },
    ));

    return PreLoginResponseModel.fromJson(json);
  }

  @override
  Future<SocialAuthUrlResponseModel> getSocialAuthenticationUrl({
    required String accessToken,
    required Map<String, dynamic> variables,
  }) async {
    final data = await _graphQL.query(
      graphqlQuery: GraphqlQueries.getSocialUrl,
      variables: variables,
      operationName: 'GET_SOCIAL_AUTHENTICATION_URL',
      options: Options(
          headers: <String, String>{
            'Authorization': accessToken,
            'x-waf-mobile-token': GainAuthConfig.wafMobileToken,
          }
      ),
    );

    return SocialAuthUrlResponseModel.fromGraphQLData(data);
  }



  @override
  Future<SocialCallbackModel> manageSocialCallback({
    required String accessToken,
    required Map<String, dynamic> variables,
  }) async {
    final data = await _graphQL.query(
      graphqlQuery: GraphqlQueries.manageSocialUrl,
      variables: variables,
      operationName: 'MANAGE_AUTHENTICATION_CALLBACK',
      options: Options(
          headers: <String, String>{
            'Authorization': accessToken,
            'x-waf-mobile-token': GainAuthConfig.wafMobileToken,
          }
      ),
    );

    return SocialCallbackModel.fromJson(data);
  }
}
