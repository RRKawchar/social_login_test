import 'package:dio/dio.dart';

import '../token_provider.dart';

/// Set on [RequestOptions.extra] to skip injecting the app session token.
/// Use for login-flow requests that pass their own [Authorization] header.
const String kSkipAuthInterceptor = 'skipAuthInterceptor';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenProvider);

  final TokenProvider _tokenProvider;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[kSkipAuthInterceptor] == true) {
      handler.next(options);
      return;
    }

    final existingAuth = options.headers['Authorization'];
    if (existingAuth != null && existingAuth.toString().isNotEmpty) {
      handler.next(options);
      return;
    }

    final token = await _tokenProvider.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = token;
    }
    handler.next(options);
  }
}
