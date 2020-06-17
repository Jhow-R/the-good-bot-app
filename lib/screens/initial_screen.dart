import 'package:flutter/material.dart';

class InitialScreen extends StatefulWidget {
  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  var username;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Color.fromRGBO(0, 0, 128, 0.5),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              'THE GOOD BOT',
              style: TextStyle(fontFamily: 'Robot', fontSize: 30),
            ),
            centerTitle: true,
          ),
          body: Align(
            alignment: Alignment.center,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  "Olá!",
                  style: TextStyle(
                      fontFamily: 'Bellota', fontSize: 30, color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage('images/avatar.png'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(
                  "Vamos conversar?",
                  style: TextStyle(
                      fontFamily: 'Bellota', fontSize: 20, color: Colors.white),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  color: Colors.white,
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      decoration: new InputDecoration(
                        hintText: 'Digite seu nome',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Nome requerido';
                        } else if (value.length < 1) {
                          return 'Nome inválido';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        username = value;
                      },
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                onPressed: () {
                  if (formKey.currentState.validate()) {
                    formKey.currentState.save();

                    Navigator.pushReplacementNamed(context, "/chat", arguments: username);
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: 200.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

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
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Sim'),
              ),
            ],
          ),
        )) ??
        false;
  }
}
