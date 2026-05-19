import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/enums/status.dart';
import '../../../../core/network/token_provider.dart';
import '../../../../core/shared/states/data_state.dart';
import '../../domain/entities/pre_login_result.dart';
import '../cubit/pre_login_cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _loginWithGoogle(BuildContext context) async {
    final preLoginState = context.read<PreLoginCubit>().state;
    if (preLoginState.status != Status.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete app pre-login before signing in with Google.'),
        ),
      );
      return;
    }

    try {
      final result = await FlutterWebAuth2.authenticate(
        url: 'https://abc123.ngrok-free.app/oauth/google',
        callbackUrlScheme: 'myapp',
        options: const FlutterWebAuth2Options(),
      );

      final uri = Uri.parse(result);
      final error = uri.queryParameters['error'];
      if (error != null && error.isNotEmpty) {
        throw Exception(error);
      }

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OAuth callback: $result')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google login failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Social Login Test')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: BlocConsumer<PreLoginCubit, DataState<PreLoginResult>>(
          listener: (context, state) {
            if (state.status == Status.success && state.data != null) {
              final tokenProvider = sl<TokenProvider>();
              if (tokenProvider is InMemoryTokenProvider) {
                tokenProvider.setToken(state.data!.accessToken);
              }
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _PreLoginStatusCard(state: state),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: state.status == Status.loading
                      ? null
                      : () => context.read<PreLoginCubit>().preLogin(),
                  child: const Text('Retry pre-login'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: state.status == Status.success
                      ? () => _loginWithGoogle(context)
                      : null,
                  child: const Text('Login with Google'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PreLoginStatusCard extends StatelessWidget {
  const _PreLoginStatusCard({required this.state});

  final DataState<PreLoginResult> state;

  @override
  Widget build(BuildContext context) {
    return switch (state.status) {
      Status.initial || Status.loading => const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text('Pre-login in progress...'),
              ],
            ),
          ),
        ),
      Status.success => Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.message,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Access token ready (${state.data?.accessToken.length ?? 0} chars)',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      Status.failure => Card(
          color: Theme.of(context).colorScheme.errorContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(state.message),
          ),
        ),
    };
  }
}
