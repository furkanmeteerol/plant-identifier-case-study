import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../models/plant_result.dart';


class ApiConnectionException implements Exception {
  const ApiConnectionException();
}


class ApiTimeoutException implements Exception {
  const ApiTimeoutException();
}


class ApiResponseException implements Exception {
  final int statusCode;

  const ApiResponseException(this.statusCode);
}


class PlantApiService {
  final String baseUrl;

  const PlantApiService({
    required this.baseUrl,
  });


  Future<PlantResult> identifyPlant(File imageFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/identify'),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType(
            'image',
            _getImageSubtype(imageFile.path),
          ),
        ),
      );

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );

      final responseBody =
          await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode != 200) {
        throw ApiResponseException(
          streamedResponse.statusCode,
        );
      }

      final json = jsonDecode(responseBody) as Map<String, dynamic>;

      return PlantResult.fromJson(json);
    } on SocketException {
      throw const ApiConnectionException();
    } on HttpException {
      throw const ApiConnectionException();
    } on FormatException {
      throw const ApiResponseException(502);
    } on TimeoutException {
      throw const ApiTimeoutException();
    }
  }


  String _getImageSubtype(String path) {
    final extension = path.split('.').last.toLowerCase();

    switch (extension) {
      case 'png':
        return 'png';
      case 'webp':
        return 'webp';
      case 'jpg':
      case 'jpeg':
      default:
        return 'jpeg';
    }
  }
}