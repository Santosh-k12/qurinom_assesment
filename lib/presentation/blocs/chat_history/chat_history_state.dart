import 'package:qurinom_assesment/data/models/chat_history_model.dart';

abstract class ChatHistoryState {}

class ChatHistoryInitial extends ChatHistoryState {}

class ChatHistoryLoading extends ChatHistoryState {}

class ChatHistoryLoaded extends ChatHistoryState {
  final List<ChatMessage> messages;

  ChatHistoryLoaded(this.messages);
}

class ChatHistoryError extends ChatHistoryState {
  final String message;

  ChatHistoryError(this.message);
}
