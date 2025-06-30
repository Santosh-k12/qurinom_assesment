import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qurinom_assesment/data/repository/chat_repository.dart';
import 'package:qurinom_assesment/presentation/blocs/chat_history/chat_history_bloc.dart';
import 'package:qurinom_assesment/presentation/blocs/chat_history/chat_history_event.dart';
import 'package:qurinom_assesment/presentation/blocs/chat_history/chat_history_state.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatId;

  const ChatDetailScreen({super.key, required this.chatId});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatHistoryBloc, ChatHistoryState>(
              builder: (context, state) {
                if (state is ChatHistoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatHistoryLoaded) {
                  final messages = state.messages;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (_, index) {
                      final msg = messages[index];
                      return ListTile(
                        title: Text(msg.content),
                        subtitle: Text(msg.senderId),
                        trailing: Text(msg.createdAt.toLocal().toString()),
                      );
                    },
                  );
                } else if (state is ChatHistoryError) {
                  return Center(child: Text(state.message));
                }

                return const SizedBox();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type a message",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final content = _controller.text.trim();
                    if (content.isNotEmpty) {
                      const senderId = "673d80bc2330e08c323f4393";

                      context.read<ChatHistoryBloc>().add(
                        SendMessageEvent(
                          chatId: widget.chatId,
                          senderId: senderId,
                          content: content,
                        ),
                      );

                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
