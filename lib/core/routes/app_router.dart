import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_login_test/core/di/service_locator.dart';
import 'package:social_login_test/features/auth/presentation/cubit/get_social_url_cubit.dart';
import 'package:social_login_test/features/auth/presentation/cubit/pre_login_cubit.dart';
import 'package:social_login_test/features/auth/presentation/page/login_page.dart';
import 'package:social_login_test/features/auth/presentation/page/login_page_tow.dart';

import 'routes_name.dart';

/// Global app router powered by `go_router`.
///
/// Use [appRouter] inside `MaterialApp.router(routerConfig: appRouter)`.
final GoRouter appRouter = GoRouter(
  initialLocation: RoutesName.login2,
  routes: <RouteBase>[
    GoRoute(
      path: RoutesName.login,
      name: 'login',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<PreLoginCubit>()),
          BlocProvider(create: (_) => sl<GetSocialUrlCubit>()),
        ],
        child: const LoginPage(),
      ),
    ),

    GoRoute(
      path: RoutesName.login2,
      name: 'login2',
      builder: (context, state) => const LoginPageTow(),
    ),
  ],
  errorPageBuilder: (context, state) => MaterialPage<void>(
    child: _RouterErrorScreen(message: state.error.toString()),
  ),
);

class _RouterErrorScreen extends StatelessWidget {
  const _RouterErrorScreen({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation error')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SelectableText(message),
      ),
    );
  }
}
