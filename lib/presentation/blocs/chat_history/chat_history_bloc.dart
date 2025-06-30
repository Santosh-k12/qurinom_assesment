import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qurinom_assesment/data/repository/chat_repository.dart';
import 'package:qurinom_assesment/presentation/blocs/chat_history/chat_history_event.dart';
import 'package:qurinom_assesment/presentation/blocs/chat_history/chat_history_state.dart';

class ChatHistoryBloc extends Bloc<ChatHistoryEvent, ChatHistoryState> {
  final ChatRepository repository;

  ChatHistoryBloc(this.repository) : super(ChatHistoryInitial()) {
    // Load chat history
    on<LoadChatHistory>((event, emit) async {
      emit(ChatHistoryLoading());
      try {
        final messages = await repository.getChatHistory(event.chatId);
        emit(ChatHistoryLoaded(messages));
      } catch (e) {
        emit(ChatHistoryError(e.toString()));
      }
    });

    on<SendMessageEvent>((event, emit) async {
      try {
        await repository.sendMessage(
          chatId: event.chatId,
          senderId: event.senderId,
          content: event.content,
          messageType: event.messageType,
          fileUrl: event.fileUrl,
        );

        final messages = await repository.getChatHistory(event.chatId);
        emit(ChatHistoryLoaded(messages));
      } catch (e) {
        emit(ChatHistoryError("Failed to send message: ${e.toString()}"));
      }
    });
  }
}
