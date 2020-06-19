import 'package:the_good_bot/models/message.dart';

import 'database_helper.dart';

class MessageRepository {
  // Instancia do Database Helper
  DatabaseHelper _databaseHelper;

  // Construtor
  MessageRepository() {
    _databaseHelper = new DatabaseHelper();
  }

    Future<List<Message>> getMessages() async {
    var connection = await _databaseHelper.connection;
    var result = await connection.query(
      "Messages",
      columns: [
        "id",
        "text",
        "messageType",
      ],
    );

    List<Message> messagesList = new List<Message>();
    for (Map i in result) {
      messagesList.add(Message.fromMap(i));
    }

    return messagesList;
  }

  Future<int> create(Message message) async {
    var connection = await _databaseHelper.connection;
    var result = await connection.insert(
      "Messages",
      message.toMap(),
    );
    return result;
  }
}
