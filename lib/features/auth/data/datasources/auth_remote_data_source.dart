import 'package:dio/dio.dart';

import '../../../../core/config/gain_auth_config.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/pre_login_response_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<PreLoginResponseModel> appLogin({
    required String appName,
    required String token,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._client);

  final DioClient _client;

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
      ),
    );

    return PreLoginResponseModel.fromJson(json);
  }
}
