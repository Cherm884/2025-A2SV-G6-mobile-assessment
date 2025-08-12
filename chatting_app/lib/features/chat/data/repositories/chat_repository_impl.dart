import 'package:chatting_app/core/error/exceptions.dart';
import 'package:chatting_app/core/error/failures.dart';
import 'package:chatting_app/core/network/network_info.dart';
import 'package:chatting_app/features/chat/data/datasource/chat_local_data_source.dart';
import 'package:chatting_app/features/chat/data/datasource/chat_remote_data_source.dart';
import 'package:chatting_app/features/chat/data/model/chat_entity_model.dart';
import 'package:chatting_app/features/chat/domain/entity/chat_entity.dart';
import 'package:chatting_app/features/chat/domain/entity/chat_message.dart';
import 'package:chatting_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatLocalDataSource localDataSource;
  
  final NetworkInfo networkInfo;

  ChatRepositoryImpl( {
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ChatMessage>>> getChatMessages(
    String id,
    String token,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final message = await remoteDataSource.getChatMessages(id, token);
        await localDataSource.cacheChatMessages(id, message);
        return Right(message);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure(message: 'No Internet connection'));
    }
  }

  @override
  Future<Either<Failure, ChatEntity>> getMyChatById(
    String chatId,
    String token,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final chat = await remoteDataSource.getMyChatById(chatId, token);
        return Right(chat);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure(message: 'No Internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<ChatEntity>>> getMyChats() async {
    if (await networkInfo.isConnected) {
      try {
        final chats = await remoteDataSource.getMyChats();
        await localDataSource.cacheChats(chats);
        return Right(chats);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure(message: 'No Internet connection'));
    }
  }

  @override
  Future<Either<Failure, ChatEntity>> initiateChat(
    String userId,
    String token,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final chat = await remoteDataSource.initiateChat(userId, token);
        return Right(chat);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure(message: 'No Internet connection'));
    }
  }
}
