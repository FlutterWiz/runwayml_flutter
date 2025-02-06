import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  group('RunwayMLClient API Tests', () {
    final String apiKey = 'YOUR_API_KEY';
    final String baseUrl = 'https://api.dev.runwayml.com/v1/image_to_video';
    final String validImageUrl = 'https://i.ibb.co/21mkFGSL/efefluter.jpg';
    final String promptText =
        'A dynamic shot of a young developer jumping with excitement, holding a Flutter Dash toy in one hand and a business card in the other. A Flutter Dart flag flutters from his pocket, caught by the breeze. Behind him, a digital development board flashes with changing lines of code, with neon lighting creating an energetic, cinematic glow around him, emphasizing the forward motion and passion for tech.';

    test('should return a valid response for video generation', () async {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: generateHeaders(apiKey),
        body: generateRequestBody(validImageUrl, promptText),
      );

      // Check if the response is successful
      expect(response.statusCode, 200);

      debugPrint('Response Body: ${response.body}');

      // Parse the response and check something specific
      final responseData = jsonDecode(response.body);
      expect(responseData, isNotNull);
      expect(responseData, contains('id'));
    });

    test('should return error for invalid API key', () async {
      final invalidApiKey = 'invalid_api_key';
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: generateHeaders(invalidApiKey),
        body: generateRequestBody(validImageUrl, promptText),
      );

      // Check if the response is an error due to invalid API key
      expect(response.statusCode, 401); // Unauthorized
    });
  });
}

// Helper function to generate the request body
String generateRequestBody(String imageUrl, String promptText) {
  return jsonEncode({
    'promptImage': imageUrl,
    'seed': 42,
    'model': 'gen3a_turbo',
    'promptText': promptText,
    'watermark': false,
    'duration': 5,
    'ratio': '1280:768',
  });
}

// Helper function to generate headers
Map<String, String> generateHeaders(String apiKey) {
  return {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
    'X-Runway-Version': '2024-11-06',
  };
}
