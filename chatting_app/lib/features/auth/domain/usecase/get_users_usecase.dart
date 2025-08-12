import 'package:chatting_app/core/error/failures.dart';
import 'package:chatting_app/features/auth/domain/entity/user.dart';
import 'package:chatting_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class GetUsersUsecase {
  final AuthRepository repository;

  GetUsersUsecase(this.repository);

  

  Future<Either<Failure,List<User>>> call(){
    return repository.getUsers();
  }
}