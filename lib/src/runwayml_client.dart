import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// A client for interacting with the RunwayML API.
class RunwayMLClient {
  /// API key for authenticating requests.
  final String apiKey;

  /// Base URL for the RunwayML API.
  static const String baseUrl = 'https://api.dev.runwayml.com/v1';

  /// Constructs a [RunwayMLClient] instance with the provided [apiKey].
  RunwayMLClient({required this.apiKey});

  /// Generates a video based on the provided image and prompt.
  ///
  /// - [promptImageUrl]: URL of the input image.
  /// - [model]: The model to use for video generation (default: "gen3a_turbo").
  /// - [promptText]: Text prompt for the video.
  /// - [ratio]: Aspect ratio of the video (e.g., "1280:768").
  /// - [seed]: Random seed for reproducibility.
  /// - [duration]: Duration of the generated video in seconds.
  /// - [watermark]: Whether to include a watermark.
  Future<TaskResponse> generateVideo({
    required String promptImageUrl,
    required String model,
    required String promptText,
    required String ratio,
    required int seed,
    required int duration,
    required bool watermark,
  }) async {
    if (!Uri.parse(promptImageUrl).isAbsolute) {
      throw ArgumentError('Invalid image URL: $promptImageUrl');
    }

    final response = await _post('/image_to_video', {
      'promptImage': promptImageUrl,
      'model': model,
      'seed': seed,
      'promptText': promptText,
      'watermark': watermark,
      'duration': duration,
      'ratio': ratio,
    });

    return TaskResponse.fromJson(response);
  }

  /// Retrieves the status of a task by its [taskId].
  Future<TaskStatusResponse> getTaskStatus(String taskId) async {
    final response = await _get('/tasks/$taskId');
    return TaskStatusResponse.fromJson(response);
  }

  /// Cancels or deletes a task with the given [taskId].
  Future<void> deleteTask(String taskId) async {
    await _delete('/tasks/$taskId');
  }

  Future<Map<String, dynamic>> _post(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers(),
      body: jsonEncode(data),
    );
    return _processResponse(response);
  }

  Future<Map<String, dynamic>> _get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers(),
    );
    return _processResponse(response);
  }

  Future<void> _delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers(),
    );
    _handleDeleteResponse(response);
  }

  Map<String, String> _headers() => {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'X-Runway-Version': '2024-11-06',
      };

  Map<String, dynamic> _processResponse(http.Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      debugPrint(HttpException(statusCode: response.statusCode, message: response.body).toString());
      throw HttpException(statusCode: response.statusCode, message: response.body);
    }
  }

  void _handleDeleteResponse(http.Response response) {
    if (response.statusCode == 204) {
      debugPrint('Task successfully deleted.');
    } else if (response.statusCode == 404) {
      debugPrint('Task not found or already deleted.');
    } else {
      throw HttpException(statusCode: response.statusCode, message: response.body);
    }
  }
}

/// Represents a response when creating a new task.
class TaskResponse {
  final String id;

  TaskResponse({required this.id});

  factory TaskResponse.fromJson(Map<String, dynamic> json) {
    return TaskResponse(id: json['id']);
  }
}

/// Represents the status of a task.
class TaskStatusResponse {
  final String id;
  final String status;
  final DateTime createdAt;
  final String? failure;
  final String? failureCode;
  final List<String>? output;
  final double? progress;

  TaskStatusResponse({
    required this.id,
    required this.status,
    required this.createdAt,
    this.failure,
    this.failureCode,
    this.output,
    this.progress,
  });

  factory TaskStatusResponse.fromJson(Map<String, dynamic> json) {
    return TaskStatusResponse(
      id: json['id'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      failure: json['failure'],
      failureCode: json['failureCode'],
      output: (json['output'] as List?)?.map((e) => e as String).toList(),
      progress: (json['progress'] as num?)?.toDouble(),
    );
  }
}

/// Custom exception for HTTP errors.
class HttpException implements Exception {
  final int statusCode;
  final String message;

  HttpException({required this.statusCode, required this.message});

  @override
  String toString() => 'HTTP $statusCode: $message';
}
