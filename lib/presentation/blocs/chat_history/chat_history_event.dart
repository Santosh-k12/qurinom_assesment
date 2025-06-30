abstract class ChatHistoryEvent {}

class LoadChatHistory extends ChatHistoryEvent {
  final String chatId;

  LoadChatHistory(this.chatId);
}

class SendMessageEvent extends ChatHistoryEvent {
  final String chatId;
  final String senderId;
  final String content;
  final String messageType;
  final String fileUrl;

  SendMessageEvent({
    required this.chatId,
    required this.senderId,
    required this.content,
    this.messageType = 'text',
    this.fileUrl = '',
  });
}
