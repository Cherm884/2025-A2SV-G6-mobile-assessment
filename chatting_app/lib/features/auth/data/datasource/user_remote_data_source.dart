import 'dart:convert';

import 'package:chatting_app/core/error/exceptions.dart';
import 'package:chatting_app/features/auth/data/datasource/user_local_data_source.dart';
import 'package:chatting_app/features/auth/data/model/user_model.dart';
import 'package:chatting_app/features/auth/domain/entity/user.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract class UserRemoteDataSource {
  Future<User> signup(String name, String email, String password);
  Future<User> login(String email, String password);
  Future<void> logout();
  Future<User> getMe();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;
  final UserLocalDataSource localDataSource;

  UserRemoteDataSourceImpl({
    required this.client,
    required this.localDataSource,
  });

  static const baseUrl =
      'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3';

  static const storageKey = 'ACCESS_TOKEN';

  @override
  Future<User> getMe() async {
    final token = await localDataSource.getAccessToken(storageKey);

    if (token == null || token.isEmpty) {
      throw CacheException(message: 'No token found in local storage');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/users/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    debugPrint(response.body);
    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      final data = jsonMap['data'];
      final user = User(
        id: data['id'],
        name: data['name'],
        email: data['email'],
      );
      return user;
    } else if (response.statusCode == 401) {
      throw AuthException(message: 'Unauthorized - token expired or invalid');
    } else {
      throw ServerException(
        message:
            'Failed to fetch user data. Status code: ${response.statusCode}',
      );
    }
  }

  @override
  Future<User> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);

      final data = jsonMap['data'];
      if (data == null) {
        throw ServerException(message: 'No data found in response');
      }

      final token = data['access_token'];
      if (token == null) {
        throw ServerException(message: 'No access token returned from API');
      }

      await localDataSource.storeAccessToken(storageKey, token);

      return await getMe();
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      final error = jsonDecode(response.body);
      throw AuthException(message: error['message'] ?? 'Authentication failed');
    } else {
      throw ServerException(message: 'Server error occurred');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await localDataSource.storeAccessToken(storageKey, '');
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<User> signup(String name, String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password, 'name': name}),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body)['data'];
      return UserModel.fromJson(data);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      final error = jsonDecode(response.body);
      throw AuthException(message: error['message'] ?? 'Authentication failed');
    } else {
      throw ServerException(message: 'Server error occurred');
    }
  }
}
