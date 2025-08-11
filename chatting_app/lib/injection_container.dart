import 'package:chatting_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:chatting_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

// Auth feature imports
import 'package:chatting_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chatting_app/features/auth/domain/usecase/login_usecase.dart';
import 'package:chatting_app/features/auth/domain/usecase/sign_up_usecase.dart';
import 'package:chatting_app/features/auth/domain/usecase/get_me_usecase.dart';
import 'package:chatting_app/features/auth/domain/usecase/log_out_usecase.dart';
import 'package:chatting_app/features/auth/data/datasource/user_remote_data_source.dart';
import 'package:chatting_app/features/auth/data/datasource/user_local_data_source.dart';
import 'package:chatting_app/core/network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      logOutUsecase: sl(),
      loginUsecase: sl(),
      signUpUsecase: sl(),
      getMeUsecase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => SignUpUsecase(sl()));
  sl.registerLazySingleton(() => GetMeUsecase(sl()));
  sl.registerLazySingleton(() => LogOutUsecase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(
      client: sl(),
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(storage: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => FlutterSecureStorage());
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
}
