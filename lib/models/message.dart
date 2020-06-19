import 'dart:convert';

class Message {
  final int id;
  final String text;
  final String name;
  final String messageType;

  Message({
    this.id,
    this.text,
    this.name,
    this.messageType = 'sent',
  });

  factory Message.fromJson(String str) => Message.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Message.fromMap(Map<String, dynamic> json) => Message(
        id: json["id"],
        text: json["text"],
        name: json["name"],
        messageType: json["messageType"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "text": text,
        "name": name,
        "messageType": messageType,
      };
}

//enum ChatMessageSender { user, chatbot }
//enum ChatMessageType { sent, received }
