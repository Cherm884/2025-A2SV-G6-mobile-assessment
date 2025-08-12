import 'package:chatting_app/features/auth/domain/entity/user.dart';
import 'package:chatting_app/features/chat/domain/entity/chat_entity.dart';

class ChatMessage {
  final String id;
  final User sender;
  final ChatEntity chat;
  final String content;
  final String type;

  ChatMessage({required this.id, required this.sender, required this.chat, required this.content, required this.type});
}
