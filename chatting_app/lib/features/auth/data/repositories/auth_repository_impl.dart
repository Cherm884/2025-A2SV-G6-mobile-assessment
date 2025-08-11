import 'package:chatting_app/core/error/exceptions.dart';
import 'package:chatting_app/core/error/failures.dart';
import 'package:chatting_app/core/network/network_info.dart';
import 'package:chatting_app/features/auth/data/datasource/user_local_data_source.dart';
import 'package:chatting_app/features/auth/data/datasource/user_remote_data_source.dart';
import 'package:chatting_app/features/auth/domain/entity/user.dart';
import 'package:chatting_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  static const storageKey = 'ACCESS_TOKEN';

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.login(email, password);
        return Right(user);
      }
      on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure(message: 'No Internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> signup(String name, String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signup(name, email, password);
        return Right(user);
      
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure(message: 'No Internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> getMe() async {
    final token = await localDataSource.getAccessToken(storageKey);
    if (token == null || token.isEmpty) {
      return Left(CacheFailure(message: 'No cached token found'));
    }

    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.getMe();
        return Right(user);
      
      } on ServerException catch (e) {
        return Left(ServerFailure(message:  e.message));
      }
    } else {
      return Left(NetworkFailure(message: 'No Internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    
    } catch (_) {
      return Left(ServerFailure(message: 'Unexpected error on logout'));
    }
  }
}
