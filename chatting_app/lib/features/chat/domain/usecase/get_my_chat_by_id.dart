import 'package:chatting_app/core/error/failures.dart';
import 'package:chatting_app/features/chat/domain/entity/chat_entity.dart';
import 'package:chatting_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class GetMyChatById {
  final ChatRepository repository;

  GetMyChatById(this.repository);

  Future<Either<Failure, ChatEntity>> call({
    required String chatId,
    required String token,
  }) async {
    return await repository.getMyChatById(chatId, token);
  }
}
