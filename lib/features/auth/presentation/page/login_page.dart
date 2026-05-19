import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

import '../../../../core/enums/status.dart';
import '../../../../core/shared/states/data_state.dart';
import '../../domain/entities/pre_login_result.dart';
import '../cubit/pre_login_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<PreLoginCubit>().preLogin();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Social Login Test')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: BlocBuilder<PreLoginCubit, DataState<PreLoginResult>>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (state.status == Status.loading)
                  const LinearProgressIndicator(),
                if (state.status == Status.failure) ...[
                  Text(
                    state.message,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => context.read<PreLoginCubit>().preLogin(),
                    child: const Text('Retry pre-login'),
                  ),
                  const SizedBox(height: 12),
                ],
                if (state.status == Status.success)
                  Text(
                    'Session ready',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: state.status == Status.success
                      ? () {}
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
