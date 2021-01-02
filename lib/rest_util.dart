import 'dart:async';
import 'dart:convert';
import 'package:flutter_template/constants.dart';
import 'package:http/http.dart' as http;

class RestUtil {
  static RestUtil _instance = new RestUtil.internal();
  RestUtil.internal();
  factory RestUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url) {
    return http.get(url).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }
}

class DefiNode {
  double lat;
  double lon;

  DefiNode({this.lat, this.lon});
}

Future<dynamic> getDefis() async {
  final jsonData = await RestUtil().get(defis_overpass_query);
  final elements = List<Map<String, dynamic>>.from(jsonData['elements']);
  final defiNodes =
      elements.map((e) => DefiNode(lat: e["lat"], lon: e["lon"])).toList();

  return defiNodes;
}
