import 'package:http/http.dart' as http;

import 'dart:convert' as convert;

class Networking {
  Future getData(String url) async {
    http.Response getResponse = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/vnd.github.v3+json"
      },
    );

    if (getResponse.statusCode == 200) {
      return getResponse;
    } else {
      print(getResponse.statusCode);
    }
    return null;
  }
}
