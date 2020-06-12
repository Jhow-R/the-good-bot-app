import 'package:dio/dio.dart';
import 'package:the_good_bot/services/ServiceConfig.dart';

class CursoService {
  static final String _endpoint = "https://panel.chatcompose.com/responseapi";
  final ServiceConfig service = new ServiceConfig(_endpoint);

  Future<void> sendMessage(String message) async {
    try {
      Response response = await service.create().post(_endpoint, data: '''{
               "user":"Jhow",
               "lang":"PT",
               "sessionid":"",
               "message":"$message"
              }''');

      if (response.statusCode == 200) {        
        //print("Comunicação bem sucedida");
        return response.data["response"][0];
      }
    } catch (error) {
      print("Service Error: $error ");
    }
  }
}
