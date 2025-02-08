# runwayml_flutter

[![pub package](https://img.shields.io/pub/v/runwayml_flutter.svg)](https://pub.dev/packages/runwayml_flutter)
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>

<p align="center">
  <img src="https://raw.githubusercontent.com/FlutterWiz/runwayml_flutter/refs/heads/main/screenshots/logo.png" width="150" height="150">
</p>

`runwayml_flutter` is a **Flutter package** that provides a **Dart wrapper** for the [Runway](https://runwayml.com) API, enabling integration of AI-generated content into Flutter apps.

🚀 **Generate videos, check task statuses, and manage tasks with ease!**

---

## ✨ Features

✅ Generate AI-powered videos from images and text prompts.

✅ Retrieve task status for ongoing tasks.

✅ Cancel or delete tasks effortlessly.

✅ Lightweight and easy to integrate with Flutter apps.

---

## 📦 Installation

Add `runwayml_flutter` to your `pubspec.yaml`:

```yaml
dependencies:
  runwayml_flutter: ^0.0.6
```

Then, run:
```sh
flutter pub get
```

---

## 🚀 Usage

To use this package, obtain a [RunwayML API key](https://dev.runwayml.com) and initialize the client:

```dart
final client = RunwayMLClient(apiKey: 'your_api_key');
```

### 🎬 Generate Video

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

### 🔍 Get Task Status

```dart
final response = await client.getTaskStatus('task_id');
print('Task Status: ${response.status}');
```

### ❌ Delete Task

```dart
await client.deleteTask('task_id');
```

---

## 📌 Example

🔹 **Prompt Image:**
<p align="center">
  <img src="https://github.com/user-attachments/assets/2e6c3da4-2399-47bb-9480-8c2c893b28f2" width="185" height="250">
</p>

🔹 **Prompt Text:**
> A dynamic shot of a young developer jumping with excitement, holding a Flutter Dash toy in one hand and a business card in the other. A Flutter Dart flag flutters from his pocket, caught by the breeze. Behind him, a digital development board flashes with changing lines of code, with neon lighting creating an energetic, cinematic glow around him, emphasizing the forward motion and passion for tech.

🔹 **Generated Videos:**

<p align="center">
  <img src="https://github.com/user-attachments/assets/9bf94f77-5f0a-4a57-8277-e63af818b1d0">
  <img src="https://github.com/user-attachments/assets/6dfea0d2-5df3-47e8-8f1a-df4dda3a7d68">
</p>

---

## 📖 More Information

📌 For detailed API documentation, visit the official [RunwayML API Docs](https://docs.dev.runwayml.com).

⚡ This package will be updated with new features and improvements over time. Always refer to the **latest documentation** for updates.

---

## 📝 API Reference

| Method | Description |
|--------|-------------|
| `generateVideo(...)` | Generates a video based on an image and a prompt. |
| `getTaskStatus(String taskId)` | Retrieves the status of a task. |
| `deleteTask(String taskId)` | Deletes a task by its ID. |

---

## 🛠️ Contributing

Contributions are welcome! Feel free to **open issues** or **submit pull requests** for improvements.

---

## 📢 Stay Connected

If you found this package helpful, **consider supporting** by:
- ⭐ Starring the [GitHub Repository](https://github.com/FlutterWiz/runwayml_flutter)
- 📺 Watch the tutorial video on **[YouTube](https://youtu.be/ocxAs_rwjYg?si=_2wMowKUeXdV4tZu)**
- 📝 Reading the full introduction on **[Medium](https://medium.com/@FlutterWiz/bringing-runway-to-flutter-introducing-runwayml_flutter-e54d103abff6)**
- 🔔 Following me on **[X](https://x.com/FlutterWiz)**
- 📺 Subscribing to my **[YouTube Channel](https://www.youtube.com/@FlutterWiz)** for more Flutter content!

Thanks for checking out `runwayml_flutter`! 🚀
