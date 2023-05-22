import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class UnpubService {

  /// Because we are serving this app from unpub server
  final  baseUrl='';

  UnpubService();

  Future<void> deletePackage(
    String name, [
    String? opaqueToken,
  ]) async {
    final headers = <String, String>{};
    if (opaqueToken != null) {
      headers['Authorization'] = 'Bearer $opaqueToken';
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/api/packages/$name'),
      headers: headers,
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<({String name, String version})>> listPackages() async {
    final response = await http.get(Uri.parse('$baseUrl/api/packages'));

    print(response.body);
    print(response.statusCode);

    if (response.statusCode != HttpStatus.ok) {
      throw Exception(response.reasonPhrase);
    }

    /// get list from response
    final map = Map<String, dynamic>.from(jsonDecode(response.body));
    final list = map['packages'] as List;

    final names = list
        .map(
          (e) => (name: e['name'] as String, version: e['version'] as String),
        )
        .toList();
    print(names);

    return names;
  }
}
