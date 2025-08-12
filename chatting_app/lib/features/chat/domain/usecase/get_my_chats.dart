import 'package:chatting_app/core/error/failures.dart';
import 'package:chatting_app/features/chat/domain/entity/chat_entity.dart';
import 'package:chatting_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class GetMyChats {
  final ChatRepository repository;

  GetMyChats(this.repository);

  Future<Either<Failure, List<ChatEntity>>> call() async {
    return await repository.getMyChats();
  }
}
