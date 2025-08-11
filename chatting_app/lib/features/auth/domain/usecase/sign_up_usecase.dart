import 'package:chatting_app/core/error/failures.dart';
import 'package:chatting_app/features/auth/domain/entity/user.dart';
import 'package:chatting_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class SignUpUsecase {
  final AuthRepository repository;

  SignUpUsecase(this.repository);

  Future<Either<Failure, User>> call(
    String name,
    String email,
    String password,
  ) {
    return repository.signup(name, email, password);
  }
}
