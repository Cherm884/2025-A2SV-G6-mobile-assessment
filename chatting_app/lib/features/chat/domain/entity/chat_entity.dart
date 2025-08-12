import 'package:chatting_app/features/auth/domain/entity/user.dart';

class ChatEntity {
  final String id;
  final User user1;
  final User user2;

  ChatEntity({
    required this.id,
    required this.user1,
    required this.user2,
  });
}