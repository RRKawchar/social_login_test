import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_login_test/core/enums/status.dart';
import 'package:social_login_test/features/auth/presentation/cubit/social_callback_cubit.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GoogleLoginWebView extends StatefulWidget {
  final String authUrl;
  final String preLoginToken;

  const GoogleLoginWebView({
    super.key,
    required this.authUrl,
    required this.preLoginToken,
  });

  @override
  State<GoogleLoginWebView> createState() => _GoogleLoginWebViewState();
}

class _GoogleLoginWebViewState extends State<GoogleLoginWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isCallbackHandled = false;

  final String _callBackPath = 'https://accounts.test.gain.io/oauth';

  String _buildAuthUrl() {
    final uri = Uri.parse(widget.authUrl);
    final params = Map<String, String>.from(uri.queryParameters);
    params['prompt'] = 'select_account';
    return uri.replace(queryParameters: params).toString();
  }

  NavigationDecision _handleNavigation(
    BuildContext context,
    NavigationRequest request,
  ) {
    final url = request.url;
    debugPrint('🔗 Navigation request: $url');

    final uri = Uri.tryParse(url);
    if (uri != null && _isExpectedCallback(uri) && !_isCallbackHandled) {
      _isCallbackHandled = true;
      final code = uri.queryParameters['code'];

      debugPrint('──────────────────────────────────────────');
      debugPrint('✅ OAuth callback received');
      debugPrint('   code     : $code');
      debugPrint('   full url : $url');
      debugPrint('──────────────────────────────────────────');

      if (context.mounted) {
        _runSocialCallbackAndPop(code: code);
      }
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  bool _isExpectedCallback(Uri uri) {
    return uri.toString().startsWith(_callBackPath);
  }

  Future<void> _runSocialCallbackAndPop({required String? code}) async {
    if (code == null || code.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OAuth callback did not contain a code.'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context, null);
      return;
    }

    try {
      final cubit = context.read<SocialCallbackCubit>();
      await cubit.handleSocialCallBack(
        accessToken: widget.preLoginToken,
        variables: <String, dynamic>{
          'inputData': <String, dynamic>{
            'prompt': 'select_account',
            'platform': 'google',
            'code': code,
          },
        },
      );

      if (!mounted) return;
      final callbackState = cubit.state;
      if (callbackState.status == Status.success) {
        Navigator.pop(context, callbackState.data);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              callbackState.message.isEmpty
                  ? 'Google login callback failed.'
                  : callbackState.message,
            ),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context, null);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Callback exchange failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context, null);
    }
  }

  @override
  void initState() {
    super.initState();

    final authUrl = _buildAuthUrl();
    debugPrint('🚀 Loading Google OAuth URL: $authUrl');

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // A real mobile browser user-agent is required so Google does not block
      // the sign-in flow and shows the account chooser for already-added
      // accounts on the device.
      ..setUserAgent(
        'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) '
        'AppleWebKit/605.1.15 (KHTML, like Gecko) '
        'Version/17.0 Mobile/15E148 Safari/604.1',
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) =>
              _handleNavigation(context, request),
          onPageStarted: (String url) {
            debugPrint('📄 Page started: $url');
            setState(() => _isLoading = true);

            // Intercept here too, in case the redirect skips onNavigationRequest
            final uri = Uri.tryParse(url);
            if (uri != null &&
                _isExpectedCallback(uri) &&
                !_isCallbackHandled) {
              _handleNavigation(
                context,
                NavigationRequest(url: url, isMainFrame: true),
              );
            }
          },
          onPageFinished: (String url) {
            debugPrint('✔️  Page finished: $url');
            setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('❌ WebView error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(authUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context, null),
        ),
        title: const Text('Sign in with Google'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
