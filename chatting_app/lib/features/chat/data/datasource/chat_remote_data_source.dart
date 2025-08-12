import 'dart:convert';

import 'package:chatting_app/features/auth/data/datasource/user_local_data_source.dart';
import 'package:chatting_app/features/chat/data/model/chat_entity_model.dart';
import 'package:chatting_app/features/chat/data/model/chat_message_model.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

abstract class ChatRemoteDataSource {
  Future<ChatEntityModel> getMyChatById(String chatId, String token);
  Future<List<ChatEntityModel>> getMyChats();
  Future<List<ChatMessageModel>> getChatMessages(String id, String token);
  Future<ChatEntityModel> initiateChat(String userId, String token);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client client;
  final UserLocalDataSource localDataSource;

  final String baseUrl =
      "https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3/chats";

  ChatRemoteDataSourceImpl({
    required this.localDataSource,
    required this.client,
  });

  static const storageKey = 'ACCESS_TOKEN';

  @override
  Future<ChatEntityModel> getMyChatById(String chatId, String token) async {
    final response = await client.get(
      Uri.parse("$baseUrl/$chatId"),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return ChatEntityModel.fromJson(jsonDecode(response.body)['data']);
    }
    throw Exception("Failed to get chat by ID");
  }

  @override
  Future<List<ChatEntityModel>> getMyChats() async {
    final token = await localDataSource.getAccessToken(storageKey);
    final response = await client.get(
      Uri.parse(baseUrl),
      headers: {'Authorization': 'Bearer $token'},
    );
    debugPrint('my token $token');
    debugPrint(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;

      return data.map((e) => ChatEntityModel.fromJson(e)).toList();
    }
    throw Exception("Failed to get chat");
  }

  @override
  Future<List<ChatMessageModel>> getChatMessages(
    String id,
    String token,
  ) async {
    final token = await localDataSource.getAccessToken(storageKey);

    final response = await client.get(
      Uri.parse('$baseUrl/$id/messages'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      return data.map((e) => ChatMessageModel.fromJson(e)).toList();
    }
    throw Exception("Failed to get chat messages");
  }

  @override
  Future<ChatEntityModel> initiateChat(String userId, String token) async {
    final response = await client.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"userId": userId}),
    );

    if (response.statusCode == 201) {
      return ChatEntityModel.fromJson(jsonDecode(response.body)['data']);
    }
    throw Exception("Failed to initiate chat");
  }
}
