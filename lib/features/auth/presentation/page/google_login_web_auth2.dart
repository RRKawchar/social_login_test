import 'package:flutter/foundation.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

class GoogleLoginWebAuth2 {
  /// Opens the system browser (Chrome Custom Tabs / ASWebAuthenticationSession).
  /// This shares cookies/sessions with the system browser, allowing users
  /// to see their already logged-in Google accounts.
  static Future<String?> authenticate(String url) async {
    try {
      debugPrint('🌐 Opening System Browser Flow: $url');

      // We use 'sociallogintest' as the fallback scheme (must match AndroidManifest.xml).
      // However, if the redirect_uri in the URL is HTTPS, we must use 'https'.
      final callbackScheme = _extractScheme(url) ?? "sociallogintest";
      debugPrint('🔁 Using callback scheme: $callbackScheme');

      final result = await FlutterWebAuth2.authenticate(
        url: url,
        callbackUrlScheme: callbackScheme,
        options: const FlutterWebAuth2Options(
          preferEphemeral: false, // Set to false to share cookies/sessions
        ),
      );

      debugPrint('✅ Received redirect: $result');

      // Parse the code from the redirect URL
      final uri = Uri.parse(result);
      return uri.queryParameters['code'];
    } catch (e) {
      debugPrint('❌ System Browser Auth Error: $e');
      return null;
    }
  }

  static String? _extractScheme(String url) {
    try {
      final uri = Uri.parse(url);
      final redirectUri = uri.queryParameters['redirect_uri'];
      if (redirectUri != null) {
        return Uri.parse(redirectUri).scheme;
      }
    } catch (_) {}
    return null;
  }
}



