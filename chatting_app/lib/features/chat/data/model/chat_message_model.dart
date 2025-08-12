import 'package:chatting_app/features/auth/data/model/user_model.dart';
import 'package:chatting_app/features/chat/data/model/chat_entity_model.dart';
import 'package:chatting_app/features/chat/domain/entity/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  ChatMessageModel({
    required super.id,
    required super.sender,
    required super.chat,
    required super.content,
    required super.type,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['_id'],
      sender: UserModel.fromJson(json['sender']),
      chat: ChatEntityModel.fromJson(json['chat']),
      content: json['content'],
      type: json['type'],
    );
  }

Map<String, dynamic> toJson() {
  return {
    '_id': id,
    'chat': ChatEntityModel.fromEntity(chat).toJson(),
    'sender': UserModel.fromEntity(sender).toJson(),
    'content': content,
    'type': type,
  };
}
}
