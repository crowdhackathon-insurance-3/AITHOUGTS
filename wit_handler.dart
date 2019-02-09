import 'package:http/http.dart' as http;
import 'dart:convert';

class WitHandler {
  final String _message_url = "https://api.wit.ai/message?q=";
  final String _auth = "Bearer " + "API_KEY";
  Future sendMsg(String msg) {
    var response = http.get(_message_url + msg,
        // Only accept JSON response
        headers: {"Authorization": _auth});
    //Intent intent = new Intent(
    return response;
  }

  String toUser(var response, String witContext) {
    var decoded = json.decode(response);
    Intent intent = Intent.fromResponse(decoded);
    Set<String> entities = Set();
    decoded['entities'].forEach((k, v) => entities.add(k));
    if (intent.value == null) return "error null";
    switch (intent.value) {
      case "symptom":
        {
          for (String entity in entities) {
            if (entity != null) {
              witContext = "symptom";
              switch (entity) {
                case "back_pain":
                  {
                    return "Θέλεις να κλείσω ραντεβού με Ορθοπεδικό;";
                  }
                  break;
                default:
                  {
                    return "Θέλεις να κλείσω ραντεβού με Παθολόγο;";
                  }
                  break;
              }
            }
          }
          return "Συγνώμη, δεν κατάλαβα";
        }
        break;
      case "change_address":
        {
          witContext = "change_address";
          return "Παρακαλώ συμπληρώστε την διεύθυνση";
        }
        break;
      case "yes_response":
        {
          witContext = "yes_response";
          return "Τα διαθέσιμα ραντεβού είναι τα παρακάτω";
        }
        break;
      case "no_response":
        {
          witContext = "no_response";
          return "Εντάξει";
        }
        break;
      case "error":
        {
          witContext = "error";
          return "Συγνώμη, δεν κατάλαβα";
        }
        break;
      default:
        {
          witContext = "error";
          return "Συγνώμη, δεν κατάλαβα";
        }
        break;
    }
  }
}

class Intent {
  String value;
  String probability;
  Intent(String value, String probability) {
    this.value = value;
    this.probability = probability;
  }

  Intent.fromResponse(var decoded) {
    if (decoded.containsKey('entities') &&
        decoded['entities'].containsKey('intent') &&
        decoded['entities']['intent'][0] != null &&
        decoded['entities']['intent'][0].containsKey('value') &&
        decoded['entities']['intent'][0].containsKey('confidence')) {
      print(decoded['entities']['intent'][0]['value']);
      print(decoded['entities']['intent'][0]['confidence']);
      this.value = decoded['entities']['intent'][0]['value'].toString();
      this.probability = decoded['entities']['intent'][0]['confidence'].toString();
    } else {
      this.value = "error";
      this.probability = "error";
    }
  }
  String get getValue => value;
  String get getProbability => probability;
}
