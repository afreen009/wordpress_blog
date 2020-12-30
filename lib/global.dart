import 'dart:convert';

import 'package:http/http.dart' as http;

String baseUrl =
    "https://public-api.wordpress.com/rest/v1.1/sites/cybdom.tech/posts";

String myBaseUrl = "https://festivalsofearth.com/wp-json/wp/v2/posts?_embed";

Future<List> getMyPosts() async {
  final responses =
      await http.get(myBaseUrl, headers: {'Accept': 'application/json'});
  var convertDataToJson = jsonDecode(responses.body);
  print(convertDataToJson);
  return convertDataToJson;
}
