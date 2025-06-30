abstract class ChatEvent {}

class FetchChats extends ChatEvent {
  final String userId;
  FetchChats(this.userId);
}
