class ChatModel {
  final String id;
  final List<Participant> participants;
  final LastMessage? lastMessage;
  final DateTime? updatedAt;

  ChatModel({
    required this.id,
    required this.participants,
    this.lastMessage,
    this.updatedAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'],
      participants: json['participants'] != null
          ? (json['participants'] as List)
                .map((e) => Participant.fromJson(e))
                .toList()
          : [],
      lastMessage: json['lastMessage'] != null
          ? LastMessage.fromJson(json['lastMessage'])
          : null,
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
    );
  }
}

class Participant {
  String? sId;
  String? name;
  String? email;

  Participant({this.sId, this.name, this.email});

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      sId: json['_id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {'_id': sId, 'name': name, 'email': email};
}

class LastMessage {
  String? content;

  LastMessage({this.content});

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(content: json['content']);
  }

  Map<String, dynamic> toJson() => {'content': content};
}
