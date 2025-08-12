import 'package:chatting_app/core/error/failures.dart';
import 'package:chatting_app/features/chat/domain/entity/chat_entity.dart';
import 'package:chatting_app/features/chat/domain/entity/chat_message.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepository {
  Future<Either<Failure,ChatEntity>> getMyChatById(String chatId, String token);
  Future<Either<Failure,List<ChatEntity>>> getMyChats();
  Future<Either<Failure,List<ChatMessage>>> getChatMessages(String id,String token);
  Future<Either<Failure,ChatEntity>> initiateChat(String userId, String token);
}
