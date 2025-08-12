import 'package:chatting_app/core/error/failures.dart';
import 'package:chatting_app/features/chat/domain/entity/chat_entity.dart';
import 'package:chatting_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class InitiateChat {
  final ChatRepository repository;

  InitiateChat(this.repository);

  Future<Either<Failure, ChatEntity>> call({
    required String userId,
    required String token,
  }) async {
    return await repository.initiateChat(userId, token);
  }
}
