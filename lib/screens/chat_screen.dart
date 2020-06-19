import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:the_good_bot/models/message.dart';
import 'package:the_good_bot/repository/messages_repository.dart';
import 'dart:io';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  MessageRepository messageRepository = MessageRepository();
  final controllerText = new TextEditingController();
  final chatbotName = 'Seu Zé';
  var messageList = <Message>[];
  var username = 'Usuário';

  @override
  Widget build(BuildContext context) {
    username = ModalRoute.of(context).settings.arguments;
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(0, 0, 128, 1),
            title: Text("The Good Bot", style: TextStyle(fontFamily: 'Robot')),
          ),
          body: Column(
            children: <Widget>[
              _buildMessageList(),
              Divider(height: 1.0),
              _buildUserInput(),
            ],
          ),
        ));
  }

  // #region Widgets
  // LISTA DE MENSAGENS
  Widget _buildMessageList() {
    return Flexible(
      child: FutureBuilder<List>(
          future: messageRepository.getMessages(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data.length > 0) {                
                return ListView.builder(
                  reverse: false,
                  padding: EdgeInsets.all(8.0),
                  itemBuilder: (_, int index) =>
                      showMessages(snapshot.data[index]),
                  itemCount: snapshot.data.length,
                );
              } else {
                return Center(
                  child: Text("Diga olá! :D"),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
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
    return chatMessage.messageType == "sent"
        ? _showSentMessage(chatMessage)
        : _showReceivedMessage(chatMessage);
  }

  // MENSAGENS À DIREITA
  Widget _showSentMessage(Message chatMessage,
      {EdgeInsets padding, TextAlign textAlign}) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(64.0, 0.0, 8.0, 0.0),
      trailing: CircleAvatar(child: Text(username.toUpperCase()[0])),
      title: Text(username, textAlign: TextAlign.right),
      subtitle: Text(chatMessage.text, textAlign: TextAlign.right),
    );
  }

  // MENSAGENS À ESQUERDA
  Widget _showReceivedMessage(Message chatMessage) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(8.0, 0.0, 64.0, 0.0),
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: AssetImage('images/avatar.png'),
      ),
      title: Text(chatbotName, textAlign: TextAlign.left),
      subtitle: Text(chatMessage.text, textAlign: TextAlign.left),
    );
  }
  // #endregion

  // #region Métodos
  // CONFIRMAÇÃO DO FECHAMENTO DO APP
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Tem certeza?'),
            content: new Text('Você quer sair do app?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Não'),
              ),
              new FlatButton(
                onPressed: () => exit(0),
                child: new Text('Sim'),
              ),
            ],
          ),
        )) ??
        false;
  }

  // COMUNICAR COM O GOOGLE CLOUD
  Future _dialogFlowRequest({String query}) async {
    // Mensagem temporária "Escrevendo..." na lista
    addMessage(name: chatbotName, text: 'Escrevendo...', type: "received");

    // Comunicação com o Google Cloud (autenticação, envio e resposta da mensagem)
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/teste.json").build();
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
        // text: 'response',
        type: "received");
  }

  // ENVIAR MENSAGEM
  void sendMessage({String text}) {
    controllerText.clear();
    addMessage(name: username, text: text, type: "sent");
  }

  // ADICIONAR MENSAGEM NA LISTA
  Future<void> addMessage({String name, String text, String type}) async {
    var message = Message(text: text, name: name, messageType: type);

    setState(() {
      messageList.insert(0, message);
    });

    if (text != "Escrevendo...") {
      await messageRepository.create(message);
    }

    if (type == "sent") {
      // Envia a mensagem para o chatbot e aguarda sua resposta
      _dialogFlowRequest(query: message.text);
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   controllerText.dispose();
  // }
  // #endregion
}
