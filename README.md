# runwayml_flutter

[![pub package](https://img.shields.io/pub/v/runwayml_flutter.svg)](https://pub.dev/packages/runwayml_flutter)

A Dart wrapper for the [RunwayML](https://runwayml.com) API to integrate AI-generated content into Flutter apps. This package allows you to generate videos, check task statuses, and manage tasks using the RunwayML API.

## Features

- Generate videos from an image and a text prompt.
- Retrieve task status for ongoing tasks.
- Cancel or delete tasks.
- Easy integration with Flutter apps.

---

## Installation

To install this package, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  runwayml_flutter: ^0.0.1
```

Then run `flutter pub get` to install the package.

## Usage

To use this package, you need a valid [RunwayML API key](https://dev.runwayml.com). Once you have the API key, you can instantiate the RunwayMLClient and make requests to the API.

### Initialize the Client

```dart
final client = RunwayMLClient(apiKey: 'your_api_key');
```

### Generate Video

Generate a video based on an input image and a prompt.

```dart
final response = await client.generateVideo(
  promptImageUrl: 'https://example.com/image.jpg',
  model: 'gen3a_turbo',
  promptText: 'A futuristic city at sunset.',
  ratio: '1280:768',
  seed: 12345,
  duration: 5,
  watermark: false,
);

print('Generated Video Task ID: ${response.id}');
```

### Get Task Status

Check the status of a task using the task ID.

```dart
final response = await client.getTaskStatus('task_id');
print('Task Status: ${response.status}');
```

### Delete Task

Delete a task by its task ID.

```dart
await client.deleteTask('task_id');
```

## Example

To get a quick glance at how to use the `runwayml_flutter` package, check out the example in the `example/lib/main.dart` file. The example demonstrates how to integrate the RunwayML API into your Flutter app.

Example `Promt Image`:

<img src="https://github.com/user-attachments/assets/2e6c3da4-2399-47bb-9480-8c2c893b28f2" width="185" height="250">


Example `Promt Text`:
A dynamic shot of a young developer jumping with excitement, holding a Flutter Dash toy in one hand and a business card in the other. A Flutter Dart flag flutters from his pocket, caught by the breeze. Behind him, a digital development board flashes with changing lines of code, with neon lighting creating an energetic, cinematic glow around him, emphasizing the forward motion and passion for tech.

Videos:

<img src="https://github.com/user-attachments/assets/9bf94f77-5f0a-4a57-8277-e63af818b1d0">

<img src="https://github.com/user-attachments/assets/6dfea0d2-5df3-47e8-8f1a-df4dda3a7d68">

---

## More Information

For detailed API documentation, including limitations and other specific details, please visit the official [RunwayML API documentation](https://docs.dev.runwayml.com).

## API Reference
- `RunwayMLClient`:
  - `generateVideo(...)`: Generates a video based on an image and a prompt.
  - `getTaskStatus(String taskId)`: Retrieves the status of a task.
  - `deleteTask(String taskId)`: Deletes a task by its ID.
  - `TaskResponse`: Represents the response for task creation, containing the task ID.
  - `TaskStatusResponse`: Represents the status of a task, including progress and output.

## Contributing

Contributions are welcome! Please feel free to open issues or submit pull requests for bug fixes or new features.
