import 'package:flutter/material.dart';
import 'package:the_good_bot/services/ChatbotService.dart';

class InitialScreen extends StatefulWidget {
  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  String message;
  CursoService cursoService = new CursoService();
  // Manipula-se o formulário através dessa chave
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 0, 128, 1),
        title: Text("The Good Bot"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextFormField(
                  decoration: new InputDecoration(
                    icon: const Icon(Icons.text_fields),
                    hintText: 'Digite o nome do curso',
                    labelText: 'Nome',
                  ),
                  onSaved: (value) {
                    message = value;
                  },
                  keyboardType: TextInputType.text,
                )),
                Expanded(
                  child: RaisedButton(
                    child: Text('Enviar mensagem'),
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        var response = cursoService.sendMessage(message);
                        print(response);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
