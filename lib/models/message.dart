// Modelo para persistência das mensagens
class Message {
  //final ChatMessageSender messageSender;
  final ChatMessageType messageType;
  final String text;
  final String name;

  Message({
    // this.messageSender = ChatMessageSender.user,
    this.messageType = ChatMessageType.sent,
    this.text,
    this.name,
  });
}

//enum ChatMessageSender { user, chatbot }
enum ChatMessageType { sent, received }
