import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qurinom_assesment/data/models/chat_model.dart';
import 'package:qurinom_assesment/data/repository/chat_repository.dart';
import 'package:qurinom_assesment/presentation/blocs/chat/chat_bloc.dart';
import 'package:qurinom_assesment/presentation/blocs/chat/chat_event.dart';
import 'package:qurinom_assesment/presentation/blocs/chat/chat_state.dart';
import 'package:qurinom_assesment/presentation/blocs/chat_history/chat_history_bloc.dart';
import 'package:qurinom_assesment/presentation/views/chat_detail_screen.dart';

class ChatListScreen extends StatelessWidget {
  final String userId;

  const ChatListScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Chats")),
      body: BlocProvider(
        create: (_) => ChatBloc(ChatRepository())..add(FetchChats(userId)),
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChatLoaded) {
              final chats = state.chats;
              if (chats.isEmpty) {
                return const Center(child: Text("No chats found."));
              }
              return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  final otherParticipant = chat.participants.firstWhere(
                    (p) => p.sId != userId,
                    orElse: () => Participant(),
                  );
                  return ListTile(
                    title: Text(otherParticipant.name ?? 'Unknown'),
                    subtitle: Text(
                      chat.lastMessage?.content ?? "No message yet",
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => ChatHistoryBloc(ChatRepository()),
                            child: ChatDetailScreen(chatId: chat.id),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is ChatError) {
              return Center(child: Text("Error: ${state.message}"));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
