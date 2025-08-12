import 'package:chatting_app/features/auth/data/model/user_model.dart';
import 'package:chatting_app/features/chat/domain/entity/chat_entity.dart';

class ChatEntityModel extends ChatEntity {
  ChatEntityModel({
    required super.id,
    required super.user1,
    required super.user2,
  });

  factory ChatEntityModel.fromJson(Map<String, dynamic> json) {
    return ChatEntityModel(
      id: json['id'],
      user1: UserModel.fromJson(json['user1']),
      user2: UserModel.fromJson(json['user2']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user1': (user1 as UserModel).toJson(),
      'user2': (user2 as UserModel).toJson(),
    };
  }

  factory ChatEntityModel.fromEntity(ChatEntity chat) {
    return ChatEntityModel(
      id: chat.id,
      user1: UserModel.fromEntity(chat.user1),
      user2: UserModel.fromEntity(chat.user2),
    );
  }

}