import 'package:chatting_app/core/error/failures.dart';
import 'package:chatting_app/features/auth/domain/entity/user.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(
    String email,
    String password,
  );

  Future<Either<Failure, User>> signup(
    String name,
    String email,
    String password,
  );

  Future<Either<Failure, User>> getMe();

  Future<Either<Failure, void>> logout();
  Future<Either<Failure,List<User>>> getUsers();
}

