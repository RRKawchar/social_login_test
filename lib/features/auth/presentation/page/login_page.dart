import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/status.dart';
import '../../../../core/shared/states/data_state.dart';
import '../../domain/entities/pre_login_result.dart';
import '../../domain/entities/social_auth_url.dart';
import '../cubit/get_social_url_cubit.dart';
import '../cubit/pre_login_cubit.dart';
import 'google_login_web_auth2.dart';
import 'google_login_web_view.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSystemBrowserFlow = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<PreLoginCubit>().preLogin();
    });
  }

  void _onGoogleLoginPressed({bool useSystemBrowser = false}) {
    setState(() {
      _isSystemBrowserFlow = useSystemBrowser;
    });

    final preLoginState = context.read<PreLoginCubit>().state;
    if (preLoginState.status != Status.success || preLoginState.data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pre-login is still in progress.')),
      );
      return;
    }

    context.read<GetSocialUrlCubit>().fetchGoogleUrl(
      accessToken: preLoginState.data!.accessToken,
      variables: const {
        'queryData': {
          'platform': 'google',
          'path': '/oauth',
          'prompt': 'select_account',
          'sub_domain': 'accounts',
        },
      },
    );
  }

  Future<void> _handleSystemBrowserLogin(String url) async {
    // This flow uses the system browser (Chrome/Safari) which shares device accounts.
    final code = await GoogleLoginWebAuth2.authenticate(url);
    if (code != null && mounted) {
      debugPrint('✅ System Browser login success: $code');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('System Browser Success! Code: $code')),
      );
      // You can now proceed with your code exchange logic
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Social Login Test')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: MultiBlocListener(
          listeners: [
            BlocListener<GetSocialUrlCubit, DataState<SocialAuthUrl>>(
              listenWhen: (previous, current) =>
                  previous.status != current.status,
              listener: (context, state) {
                if (state.status == Status.success && state.data != null) {
                  final preLoginData = context.read<PreLoginCubit>().state.data;
                  if (preLoginData == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pre-login data not available.')),
                    );
                    return;
                  }

                  if (_isSystemBrowserFlow) {
                    _handleSystemBrowserLogin(state.data!.url);
                  } else {
                    // Method 2: In-App WebView
                    Navigator.of(context).push<String?>(
                      MaterialPageRoute(
                        builder: (_) => GoogleLoginWebView(
                          authUrl: state.data!.url,
                          preLoginToken: preLoginData.accessToken,
                        ),
                      ),
                    ).then((code) {
                      if (code != null && mounted) {
                        debugPrint('✅ WebView login success: $code');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('WebView Success! Code: $code')),
                        );
                      }
                    });
                  }
                } else if (state.status == Status.failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<PreLoginCubit, DataState<PreLoginResult>>(
            builder: (context, preLoginState) {
              return BlocBuilder<GetSocialUrlCubit, DataState<SocialAuthUrl>>(
                builder: (context, socialUrlState) {
                  final isPreLoginReady =
                      preLoginState.status == Status.success;
                  final isFetchingUrl =
                      socialUrlState.status == Status.loading;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (preLoginState.status == Status.loading)
                        const LinearProgressIndicator(),
                      if (preLoginState.status == Status.failure) ...[
                        Text(
                          preLoginState.message,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () =>
                              context.read<PreLoginCubit>().preLogin(),
                          child: const Text('Retry pre-login'),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (isPreLoginReady)
                        Text(
                          'Session ready',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      if (socialUrlState.status == Status.success &&
                          socialUrlState.data != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Last OAuth URL (${socialUrlState.data!.url.length} chars)',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: isPreLoginReady && !isFetchingUrl
                            ? () => _onGoogleLoginPressed(useSystemBrowser: false)
                            : null,
                        child: isFetchingUrl && !_isSystemBrowserFlow
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Login with Google (WebView)'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: isPreLoginReady && !isFetchingUrl
                            ? () => _onGoogleLoginPressed(useSystemBrowser: true)
                            : null,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        child: isFetchingUrl && _isSystemBrowserFlow
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Login with Google (System Browser)'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
