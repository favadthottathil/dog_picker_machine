import 'dart:convert';

import 'package:http/http.dart' as http;

class ImagePickController {
  var apiEndpoint = 'https://dog.ceo/api/breeds/image/random';

  Future<String> getImage() async {
    final url = Uri.parse(apiEndpoint);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      dynamic data = json.decode(response.body);

      String url = data['message'];

      return url;
    } else {
      return '';
    }
  }
}
