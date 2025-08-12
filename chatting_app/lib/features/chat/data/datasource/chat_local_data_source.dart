import 'dart:convert';

import 'package:chatting_app/features/chat/data/model/chat_entity_model.dart';
import 'package:chatting_app/features/chat/data/model/chat_message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ChatLocalDataSource {
  Future<void> cacheChats(List<ChatEntityModel> chats);

  Future<List<ChatEntityModel>> getCachedChats();

  Future<void> cacheChatMessages(String chatId, List<ChatMessageModel> messages);

  Future<List<ChatMessageModel>> getCachedChatMessages(String chatId);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cachedChatsKey = 'CACHED_CHATS';

  String _cachedChatMessagesKey(String chatId) => 'CACHED_CHAT_MESSAGES_$chatId';

  ChatLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheChats(List<ChatEntityModel> chats) async {
    final List<String> jsonChats = chats.map((chat) => json.encode(chat.toJson())).toList();
    await sharedPreferences.setStringList(cachedChatsKey, jsonChats);
  }

  @override
  Future<List<ChatEntityModel>> getCachedChats() async {
    final jsonChats = sharedPreferences.getStringList(cachedChatsKey);
    if (jsonChats != null && jsonChats.isNotEmpty) {
      return jsonChats.map((jsonChat) => ChatEntityModel.fromJson(json.decode(jsonChat))).toList();
    }
    return [];
  }

  @override
  Future<void> cacheChatMessages(String chatId, List<ChatMessageModel> messages) async {
    final List<String> jsonMessages = messages.map((msg) => json.encode(msg.toJson())).toList();
    await sharedPreferences.setStringList(_cachedChatMessagesKey(chatId), jsonMessages);
  }

  @override
  Future<List<ChatMessageModel>> getCachedChatMessages(String chatId) async {
    final jsonMessages = sharedPreferences.getStringList(_cachedChatMessagesKey(chatId));
    if (jsonMessages != null && jsonMessages.isNotEmpty) {
      return jsonMessages.map((jsonMsg) => ChatMessageModel.fromJson(json.decode(jsonMsg))).toList();
    }
    return [];
  }
}
