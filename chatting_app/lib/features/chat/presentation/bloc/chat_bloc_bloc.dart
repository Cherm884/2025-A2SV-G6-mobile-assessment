import 'package:chatting_app/features/chat/domain/usecase/get_chat_messages.dart';
import 'package:chatting_app/features/chat/domain/usecase/get_my_chats.dart';
import 'package:chatting_app/features/chat/domain/usecase/initiate_chat.dart';
import 'package:chatting_app/features/chat/presentation/bloc/chat_bloc_event.dart';
import 'package:chatting_app/features/chat/presentation/bloc/chat_bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatting_app/core/error/failures.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetMyChats getMyChatsUseCase;
  final GetChatMessages getMyChatMessagesUseCase;
  final InitiateChat initiateChatUseCase;

  ChatBloc({
    required this.getMyChatsUseCase,
    required this.getMyChatMessagesUseCase,
    required this.initiateChatUseCase,
  }) : super(ChatInitial()) {
    on<LoadChats>(_onLoadChats);
    on<LoadChatMessages>(_onLoadChatMessages);
    on<InitiateChatEvent>(_onInitiateChat);
  }

  Future<void> _onLoadChats(LoadChats event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    final failureOrChats = await getMyChatsUseCase();
    failureOrChats.fold(
      (failure) => emit(ChatError(_mapFailureToMessage(failure))),
      (chats) => emit(ChatsLoaded(chats)), 
    );
  }

  Future<void> _onLoadChatMessages(LoadChatMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    final failureOrMessages = await getMyChatMessagesUseCase(event.chatId, event.token);
    failureOrMessages.fold(
      (failure) => emit(ChatError(_mapFailureToMessage(failure))),
      (messages) => emit(ChatMessagesLoaded(messages)),
    );
  }

  Future<void> _onInitiateChat(InitiateChatEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    final failureOrChat = await initiateChatUseCase(userId: event.userId, token: event.token);
    failureOrChat.fold(
      (failure) => emit(ChatError(_mapFailureToMessage(failure))),
      (chat) => emit(ChatInitiated(chat)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return failure is ServerFailure ? "Server error occurred" : "Unexpected error";
  }
}
