
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/acled_event.dart';

class ACLEDService {
  final String apiKey = 'E7NXuEK*9Dr8Du*LYPtd';
  final String email = 'luis.barros@estudante.ifro.edu.br';
  final String baseUrl = 'https://api.acleddata.com/acled/read';

  Future<List<ACLEDEvent>> searchEvents({
    String? country,
    String? keyword,
  }) async {
    String url = '$baseUrl?key=$apiKey&email=$email&export_type=json';
    if (country != null && country.isNotEmpty) {
      url += '&country=$country';
    }
    if (keyword != null && keyword.isNotEmpty) {
      url += '&notes=$keyword';
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final events = (data['data'] as List)
            .map((item) => ACLEDEvent.fromJson(item))
            .toList();
        return events;
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      throw Exception('Failed to load events');
    }
  }
}
