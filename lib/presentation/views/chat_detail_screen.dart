import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qurinom_assesment/presentation/blocs/chat_history/chat_history_bloc.dart';
import 'package:qurinom_assesment/presentation/blocs/chat_history/chat_history_event.dart';
import 'package:qurinom_assesment/presentation/blocs/chat_history/chat_history_state.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatId;
  final String senderId;

  const ChatDetailScreen({
    super.key,
    required this.chatId,
    required this.senderId,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ChatHistoryBloc>().add(LoadChatHistory(widget.chatId));
    });
  }

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
                      context.read<ChatHistoryBloc>().add(
                        SendMessageEvent(
                          chatId: widget.chatId,
                          senderId: widget.senderId,
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
