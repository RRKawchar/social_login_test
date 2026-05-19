import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/pre_login_usecase.dart';
import '../../features/auth/presentation/cubit/pre_login_cubit.dart';
import '../network/dio_client.dart';
import '../network/dio_factory.dart';
import '../network/graphql/graphql_client.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../network/interceptors/error_interceptor.dart';
import '../network/interceptors/logging_interceptor.dart';
import '../network/token_provider.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ───── Core: session ─────
  sl.registerLazySingleton<TokenProvider>(InMemoryTokenProvider.new);

  // ───── Core: network ─────
  sl.registerLazySingleton(LoggingInterceptor.new);
  sl.registerLazySingleton<ErrorInterceptor>(ErrorInterceptor.new);
  sl.registerLazySingleton(
    () => AuthInterceptor(sl<TokenProvider>()),
  );
  sl.registerLazySingleton<Dio>(
    () => DioFactory.create(
      authInterceptor: sl(),
      loggingInterceptor: sl(),
      errorInterceptor: sl(),
    ),
  );
  sl.registerLazySingleton(() => DioClient(sl()));
  sl.registerLazySingleton(() => GraphQLDioClient(sl()));

  // ───── Auth feature ─────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton(() => PreLoginUseCase(sl()));
  sl.registerFactory(() => PreLoginCubit(sl()));
}
