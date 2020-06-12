import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:the_good_bot/models/message.dart';

class InitialScreen extends StatefulWidget {
  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  final messageList = <Message>[];
  final controllerText = new TextEditingController();
  final chatbotName = 'Seu Zé';
  var username;

  @override
  Widget build(BuildContext context) {
    //username = ModalRoute.of(context).settings.arguments;
    username = "Jhow";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 0, 128, 1),
        title: Text("The Good Bot"),
      ),
      body: Column(
        children: <Widget>[
          _buildMessageList(),
          Divider(height: 1.0),
          _buildUserInput(),
        ],
      ),
    );
  }

  // #region Widgets
  // LISTA DE MENSAGENS
  Widget _buildMessageList() {
    return Flexible(
      child: ListView.builder(
        reverse: true,
        padding: EdgeInsets.all(8.0),
        itemBuilder: (_, int index) => showMessages(messageList[index]),
        itemCount: messageList.length,
      ),
    );
  }

  // CAMPO DE TEXTO
  Widget _buildTextField() {
    return new Flexible(
      child: new TextField(
        controller: controllerText,
        decoration: new InputDecoration.collapsed(
          hintText: "Digite sua mensagem",
        ),
      ),
    );
  }

  // BOTÃO DE ENVIO
  Widget _buildSendButton() {
    return new Container(
      margin: new EdgeInsets.only(left: 8.0),
      child: new IconButton(
          icon: new Icon(Icons.send, color: Theme.of(context).accentColor),
          onPressed: () {
            if (controllerText.text.isNotEmpty) {
              sendMessage(text: controllerText.text);
            }
          }),
    );
  }

  // INPUT DO USUÁRIO: CAMPO DE TEXTO + BOTÃO DE ENVIO
  Widget _buildUserInput() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(
        children: <Widget>[
          _buildTextField(),
          _buildSendButton(),
        ],
      ),
    );
  }

  // MENSAGENS (esquerda ou direita)
  Widget showMessages(Message chatMessage) {
    return chatMessage.messageType == ChatMessageType.sent
        ? _showSentMessage(chatMessage)
        : _showReceivedMessage(chatMessage);
  }

  // MENSAGENS À DIREITA
  Widget _showSentMessage(Message chatMessage,
      {EdgeInsets padding, TextAlign textAlign}) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(64.0, 0.0, 8.0, 0.0),
      trailing: CircleAvatar(child: Text(chatMessage.name.toUpperCase()[0])),
      title: Text(chatMessage.name, textAlign: TextAlign.right),
      subtitle: Text(chatMessage.text, textAlign: TextAlign.right),
    );
  }

  // MENSAGENS À ESQUERDA
  Widget _showReceivedMessage(Message chatMessage) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(8.0, 0.0, 64.0, 0.0),
      leading: CircleAvatar(child: Text(chatMessage.name.toUpperCase()[0])),
      title: Text(chatMessage.name, textAlign: TextAlign.left),
      subtitle: Text(chatMessage.text, textAlign: TextAlign.left),
    );
  }
  // #endregion

  // #region Métodos
  // COMUNICAR COM O GOOGLE CLOUD
  Future _dialogFlowRequest({String query}) async {
    // Mensagem temporária "Escrevendo..." na lista
    addMessage(
        name: chatbotName,
        text: 'Escrevendo...',
        type: ChatMessageType.received);

    // Comunicação com o Google Cloud (autenticação, envio e resposta da mensagem)
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/credentials.json").build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: "pt-BR");
    AIResponse response = await dialogflow.detectIntent(query);

    // Remove a mensagem temporária
    setState(() {
      messageList.removeAt(0);
    });

    // Resposta do chatbot
    addMessage(
        name: chatbotName,
        text: response.getMessage() ?? '',
        type: ChatMessageType.received);
  }

  // ENVIAR MENSAGEM
  void sendMessage({String text}) {
    controllerText.clear();
    addMessage(name: username, text: text, type: ChatMessageType.sent);
  }

  // ADICIONAR MENSAGEM NA LISTA
  void addMessage({String name, String text, ChatMessageType type}) {
    var message = Message(text: text, name: name, messageType: type);

    setState(() {
      messageList.insert(0, message);
    });

    if (type == ChatMessageType.sent) {
      // Envia a mensagem para o chatbot e aguarda sua resposta
      _dialogFlowRequest(query: message.text);
    }
  }
  // #endregion
}
