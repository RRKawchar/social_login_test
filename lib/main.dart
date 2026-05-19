import 'package:flutter/material.dart';
import 'package:social_login_test/core/di/service_locator.dart';
import 'package:social_login_test/core/routes/app_router.dart';
import 'package:social_login_test/features/auth/presentation/page/login_page_tow.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Social Login Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );


  }
}
