import 'package:chatting_app/core/error/failures.dart';
import 'package:chatting_app/features/auth/domain/entity/user.dart';
import 'package:chatting_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  Future<Either<Failure, User>> call(String email, String password) {
    return repository.login(email, password);
  }
}
