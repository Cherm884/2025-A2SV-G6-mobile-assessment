import 'package:chatting_app/core/error/failures.dart';
import 'package:chatting_app/features/chat/domain/entity/chat_message.dart';
import 'package:chatting_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class GetChatMessages {
  final ChatRepository repository;

  GetChatMessages(this.repository);

  Future<Either<Failure, List<ChatMessage>>> call(String id,String token) async {
    return await repository.getChatMessages(id,token);
  }
}
