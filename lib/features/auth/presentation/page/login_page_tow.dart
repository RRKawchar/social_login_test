import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/gain_auth_config.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/graphql/graphql_queries.dart';
import '../../data/models/pre_login_response_model.dart';

/// Debug page: [setState] + plain Dio (no interceptors, no cubit).
class LoginPageTow extends StatefulWidget {
  const LoginPageTow({super.key});

  @override
  State<LoginPageTow> createState() => _LoginPageTowState();
}

class _LoginPageTowState extends State<LoginPageTow> {
  /// Plain Dio — no [AuthInterceptor], no logging. Closest to Apollo Sandbox.
  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  String? _preLoginToken;
  String? _oauthUrl;
  String? _error;
  bool _preLoginLoading = false;
  bool _urlLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _runPreLogin());
  }

  Future<void> _runPreLogin() async {
    setState(() {
      _preLoginLoading = true;
      _error = null;
    });

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.appLogin,
        data: <String, String>{
          'app_name': GainAuthConfig.appName,
          'token': GainAuthConfig.appLoginToken,
        },
        options: Options(
          headers: <String, String>{
            'x-waf-mobile-token': GainAuthConfig.wafMobileToken,
          },
        ),
      );

      final model = PreLoginResponseModel.fromJson(response.data ?? {});
      if (model.accessToken.isEmpty) {
        throw Exception('access_token missing');
      }

      setState(() {
        _preLoginToken = model.accessToken;
        _preLoginLoading = false;
      });
    } catch (e) {
      setState(() {
        _preLoginLoading = false;
        _error = 'Pre-login: $e';
      });
    }
  }

  Future<void> _fetchGoogleUrl() async {
    final token = _preLoginToken;
    if (token == null || token.isEmpty) {
      setState(() => _error = 'Wait for pre-login token.');
      return;
    }

    setState(() {
      _urlLoading = true;
      _error = null;
      _oauthUrl = null;
    });

    try {
      // Mobile WAF often blocks /graphql without x-waf-mobile-token (Apollo browser skips this).
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.graphQL,
        data: <String, dynamic>{
          'query': GraphqlQueries.getSocialUrl,
          'operationName': 'GET_SOCIAL_AUTHENTICATION_URL',
          'variables': <String, dynamic>{
            'queryData': <String, String>{
              'platform': 'google',
              'path': '/oauth',
              'prompt': 'select_account',
              'sub_domain': 'liton',
            },
          },
        },
        options: Options(
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'x-waf-mobile-token': GainAuthConfig.wafMobileToken,
          },
        ),
      );

      final url =
          response.data?['data']?['getSocialAuthenticationURL'] as String?;
      if (url == null || url.isEmpty) {
        throw Exception(response.data?.toString() ?? 'Empty URL');
      }

      setState(() {
        _oauthUrl = url;
        _urlLoading = false;
      });
      debugPrint('OAUTH URL => $url');
    } on DioException catch (e) {
      final isHtml403 = e.response?.statusCode == 403 &&
          e.response?.data.toString().contains('<html>') == true;
      setState(() {
        _urlLoading = false;
        _error = isHtml403
            ? '403 WAF block. Headers sent: Authorization + x-waf-mobile-token. '
                'Compare token with Apollo (must be fresh pre-login token).'
            : 'GraphQL ${e.response?.statusCode}: ${e.response?.data}';
      });
    } catch (e) {
      setState(() {
        _urlLoading = false;
        _error = '$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasToken = _preLoginToken != null && _preLoginToken!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Login Page 2 (debug)')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _preLoginLoading
                  ? 'Pre-login...'
                  : hasToken
                      ? 'Token: ${_preLoginToken!.substring(0, 20)}...'
                      : 'No token',
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            if (_oauthUrl != null) ...[
              const SizedBox(height: 12),
              SelectableText(_oauthUrl!, style: const TextStyle(fontSize: 12)),
            ],
            const Spacer(),
            OutlinedButton(
              onPressed: _preLoginLoading ? null : _runPreLogin,
              child: const Text('Retry pre-login'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: hasToken && !_urlLoading ? _fetchGoogleUrl : null,
              child: _urlLoading
                  ? const CircularProgressIndicator()
                  : const Text('Get Google URL'),
            ),
          ],
        ),
      ),
    );
  }
}
