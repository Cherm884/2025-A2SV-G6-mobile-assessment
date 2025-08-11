import 'package:chatting_app/core/error/failures.dart';
import 'package:chatting_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class LogOutUsecase {
  final AuthRepository repository;

  LogOutUsecase(this.repository);

  Future<Either<Failure,void>> call(){
    return repository.logout();
  }
}

