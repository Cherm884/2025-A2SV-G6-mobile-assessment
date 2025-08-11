class ServerException implements Exception {
  final String message;
  ServerException({required this.message});

  @override
  String toString() =>
      message != null ? 'ServerException: $message' : 'ServerException';
}

class AuthException implements Exception {
  final String message;
  AuthException({required this.message});

  @override
  String toString() => 'AuthException: $message';
}

class CacheException implements Exception {
  final String? message;
  CacheException({this.message});

  @override
  String toString() =>
      message != null ? 'CacheException: $message' : 'CacheException';
}
