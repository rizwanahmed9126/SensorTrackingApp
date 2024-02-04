import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../../commons/constants.dart';

abstract class RemoteDataSource {
  Future<bool> uploadLogs(String body);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;

  RemoteDataSourceImpl({required this.client});

  @override
  Future<bool> uploadLogs(String body) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(Urls.baseUrl));
    request.body = body;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      debugPrint('Batch sent successfully');
      return true;
    } else {
      debugPrint('Failed to send batch ${response.statusCode}');
      return false;
    }
  }
}
