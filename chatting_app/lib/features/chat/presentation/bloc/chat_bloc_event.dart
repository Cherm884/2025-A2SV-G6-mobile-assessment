import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}



class LoadChatMessages extends ChatEvent {
  final String chatId;
  final String token;
  const LoadChatMessages({required this.chatId, required this.token});

  @override
  List<Object?> get props => [chatId, token];
}

class InitiateChatEvent extends ChatEvent {
  final String userId;
  final String token;
  const InitiateChatEvent({required this.userId, required this.token});

  @override
  List<Object?> get props => [userId, token];
}

class LoadChats extends ChatEvent{
  
}