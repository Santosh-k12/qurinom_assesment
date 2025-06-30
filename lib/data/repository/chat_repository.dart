import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qurinom_assesment/data/models/chat_history_model.dart';
import 'package:qurinom_assesment/data/models/chat_model.dart';

class ChatRepository {
  final String baseUrl = "http://45.129.87.38:6065";

  Future<List<ChatModel>> getUserChats(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/chats/user-chats/$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((chat) => ChatModel.fromJson(chat)).toList();
    } else {
      throw Exception('Failed to fetch chats');
    }
  }

  Future<List<ChatMessage>> getChatHistory(String chatId) async {
    final url =
        'http://45.129.87.38:6065/messages/get-messagesformobile/$chatId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ChatMessage.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load chat history');
    }
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    String messageType = "text",
    String fileUrl = "",
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/messages/sendMessage'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "chatId": chatId,
        "senderId": senderId,
        "content": content,
        "messageType": messageType,
        "fileUrl": fileUrl,
      }),
    );

    if (response.statusCode >= 400) {
      throw Exception('Failed to send message: ${response.body}');
    }

    final responseData = jsonDecode(response.body);
    print(" Message sent: $responseData");
  }
}
