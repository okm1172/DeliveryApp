import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAssist{
  static Future<dynamic> receiveRequest(String url) async{
    http.Response httpResponse = await http.get(Uri.parse(url));

    try{
      if(httpResponse.statusCode == 200){
        String responseData = httpResponse.body; //json
        var decodeResponseData = jsonDecode(responseData); //map

        return decodeResponseData;
      }
      else{
        return "Error Occured. Failed. No Response";
      }
    } catch(exp){
      return "Error Occured. Failed. No Response";
    }
  }
}