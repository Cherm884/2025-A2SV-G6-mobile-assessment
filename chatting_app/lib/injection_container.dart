import 'package:chatting_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:chatting_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:chatting_app/features/auth/domain/usecase/get_users_usecase.dart';
import 'package:chatting_app/features/chat/data/datasource/chat_local_data_source.dart';
import 'package:chatting_app/features/chat/data/datasource/chat_remote_data_source.dart';
import 'package:chatting_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:chatting_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:chatting_app/features/chat/domain/usecase/get_chat_messages.dart';
import 'package:chatting_app/features/chat/domain/usecase/get_my_chat_by_id.dart';
import 'package:chatting_app/features/chat/domain/usecase/get_my_chats.dart';
import 'package:chatting_app/features/chat/domain/usecase/initiate_chat.dart';
import 'package:chatting_app/features/chat/presentation/bloc/chat_bloc_bloc.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerFactory(
    () => AuthBloc(
      logOutUsecase: sl(),
      loginUsecase: sl(),
      signUpUsecase: sl(),
      getMeUsecase: sl(),
      getUsersUsecase: sl(),
    ),
  );
  sl.registerFactory(
    () => ChatBloc(
      getMyChatsUseCase: sl(),
      getMyChatMessagesUseCase: sl(),
      initiateChatUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => SignUpUsecase(sl()));
  sl.registerLazySingleton(() => GetMeUsecase(sl()));
  sl.registerLazySingleton(() => LogOutUsecase(sl()));
  sl.registerLazySingleton(() => GetUsersUsecase(sl()));
  sl.registerLazySingleton(() => GetChatMessages(sl()));
  sl.registerLazySingleton(() => InitiateChat(sl()));
  sl.registerLazySingleton(() => GetMyChatById(sl()));
  sl.registerLazySingleton(() => GetMyChats(sl()));
  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(client: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(client: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(storage: sl()),
  );

  sl.registerLazySingleton<ChatLocalDataSource>(
    () => ChatLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => FlutterSecureStorage());

  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
}
