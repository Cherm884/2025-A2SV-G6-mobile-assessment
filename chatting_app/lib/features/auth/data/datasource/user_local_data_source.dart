import 'package:chatting_app/core/error/exceptions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class UserLocalDataSource {
  Future<String?> getAccessToken(String user);
  Future<void> storeAccessToken(String key, String accessToken);
  Future<void> deleteAccessToken(String key);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final FlutterSecureStorage storage;

  UserLocalDataSourceImpl({required this.storage});

  @override
  Future<void> deleteAccessToken(String key) async {
    try {
      await storage.delete(key: key);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<String?> getAccessToken(String user) async {
    try {
      final token = await storage.read(key: user);
      return token;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> storeAccessToken(String key, String accessToken) async {
    try {
      await storage.write(key: key, value: accessToken);
    } catch (e) {
      throw CacheException();
    }
  }
}
