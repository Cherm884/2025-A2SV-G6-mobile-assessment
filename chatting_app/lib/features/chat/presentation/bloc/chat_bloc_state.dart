import 'package:chatting_app/features/chat/domain/entity/chat_message.dart';
import 'package:equatable/equatable.dart';
import 'package:chatting_app/features/chat/domain/entity/chat_entity.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];

  get chats => null;
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatsLoaded extends ChatState{
  @override
  final List<ChatEntity> chats;

  const ChatsLoaded(this.chats);
  @override
  List<Object> get props => [chats];
}

class ChatMessagesLoaded extends ChatState {
  final List<ChatMessage> messages;  
  const ChatMessagesLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatInitiated extends ChatState {
  final ChatEntity chat;
  const ChatInitiated(this.chat);

  @override
  List<Object?> get props => [chat];
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}


