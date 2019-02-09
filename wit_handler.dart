import 'package:http/http.dart' as http;
import 'dart:convert';

class WitHandler {
  final String _message_url = "https://api.wit.ai/message?q=";
  final String _auth = "Bearer " + "API_KEY";
  Future sendMsg(String msg)
  {
    var response = http.get(
      _message_url + msg,
      // Only accept JSON response
      headers: {"Authorization": _auth}
    );
    //Intent intent = new Intent(
    return response;
  }
  String toUser(var response)
  {
    Intent intent = Intent.fromResponse(response);
    switch(intent.value) {
      case "time": { 
        return "Απάντηση για χρόνο";
      } 
      break;

      default: { 
        return "Άλλη περίπτωση"; 
      }
      break;
    } 
  } 
}

class Intent {
  String value;
  String probability;
  Intent(String value, String probability)
  {
    this.value = value;
    this.probability = probability; 
  }
  Intent.fromResponse(var responseBody)
  {
    var decoded = json.decode(responseBody);
    print(decoded['entities']['intent'][0]['value']);
    print(decoded['entities']['intent'][0]['confidence']);
    this.value = decoded['entities']['intent'][0]['value'].toString();
    this.probability = decoded['entities']['intent'][0]['confidence'].toString();
  }
  String get getValue => value;
  String get getProbability => probability;
}
