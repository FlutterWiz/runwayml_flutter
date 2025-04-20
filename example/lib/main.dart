// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:runwayml_flutter/runwayml_flutter.dart';

void main() {
  runApp(const AppWidget());
}

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  AppWidgetState createState() => AppWidgetState();
}

class AppWidgetState extends State<AppWidget> {
  // This will be used to interact with the RunwayML API and perform video generation tasks.
  late RunwayMLClient client;

  // This is a controller for the video player. It's used to initialize and control the video playback once the video URL is retrieved.
  VideoPlayerController? _videoPlayerController;

  // This holds the URL of the video that will be generated and shown in the UI once the task is complete.
  String? videoUrl;

  // This holds the unique task ID that is used to track the status of the video generation task.
  String? taskId;

  // This holds the current progress as a string, which will be used to show percentage or status updates (e.g., "50%" or "Initializing...").
  String? progressText;

  // A boolean flag to track whether the video generation is in progress and loading.
  bool isLoading = false;

  // A boolean flag to track whether the task cancellation process is in progress, so we avoid multiple cancel clicks.
  bool isCanceling = false;

  // A boolean flag to track whether the video generation process is ongoing. This ensures the generate button isn't tapped repeatedly.
  bool isGenerating = false;

  // A boolean flag to track whether the app is polling for updates from the API regarding the task status.
  bool isPolling = false;

  @override
  void initState() {
    super.initState();
    // apiKey starts with 'key_'
    client = RunwayMLClient(apiKey: 'YOUR_API_KEY');
  }

  void generateVideo() async {
    setState(() {
      isLoading = true;
      isCanceling = false;
      isGenerating = true;
      videoUrl = null;
      taskId = null;
      progressText = '';
    });

    try {
      final TaskResponse response = await client.generateVideo(
        promptImageUrl: 'https://i.ibb.co/21mkFGSL/efefluter.jpg',
        model: 'gen3a_turbo',
        seed: 42,
        promptText:
            'A dynamic shot of a young developer jumping with excitement, holding a Flutter Dash toy in one hand and a business card in the other. A Flutter Dart flag flutters from his pocket, caught by the breeze. Behind him, a digital development board flashes with changing lines of code, with neon lighting creating an energetic, cinematic glow around him, emphasizing the forward motion and passion for tech.',
        watermark: false,
        duration: 5,
        ratio: '1280:768',
      );

      setState(() {
        taskId = response.id;
      });

      await checkTaskStatus();
    } catch (e) {
      setState(() {
        videoUrl = 'Error: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
        isGenerating = false;
      });
    }
  }

  Future<void> checkTaskStatus() async {
    isPolling = true;

    while (isPolling && taskId != null) {
      try {
        final TaskStatusResponse statusResponse = await client.getTaskStatus(
          taskId!,
        );

        setState(() {
          progressText =
              statusResponse.progress == null
                  ? '0.0%'
                  : '${statusResponse.progress}%';
        });

        if (statusResponse.status == 'SUCCEEDED') {
          setState(() {
            videoUrl = statusResponse.output?.first;
            isPolling = false;
            progressText = null;
          });

          if (videoUrl != null) {
            _videoPlayerController = VideoPlayerController.networkUrl(
                Uri.parse(videoUrl!),
              )
              ..initialize().then((_) {
                setState(() {
                  _videoPlayerController?.setLooping(true);
                });
                _videoPlayerController?.play();
              });
          }

          break;
        } else if (statusResponse.status == 'FAILED') {
          setState(() {
            videoUrl = 'Video generation failed';
            isPolling = false;
            progressText = null;
          });

          break;
        }

        await Future.delayed(const Duration(seconds: 3));
      } catch (e) {
        setState(() {
          videoUrl = 'Error checking task status: $e';
          isPolling = false;
          progressText = null;
        });

        break;
      }
    }
  }

  Future<void> cancelTask() async {
    if (taskId == null || isCanceling) return;

    setState(() {
      isCanceling = true;
      progressText = 'Canceling...';
    });

    try {
      await client.deleteTask(taskId!);
      setState(() {
        videoUrl = 'Task canceled successfully.';
        taskId = null;
        isPolling = false;
        progressText = null;
      });
    } catch (e) {
      setState(() {
        videoUrl = 'Error canceling task: $e';
        progressText = null;
      });
    } finally {
      setState(() {
        isCanceling = false;
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('RunwayML Flutter Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              isGenerating
                  ? const Text('Generating Video...')
                  : ElevatedButton(
                    onPressed: generateVideo,
                    child: const Text('Generate Video'),
                  ),
              if (taskId != null && isLoading)
                isCanceling
                    ? const Text('Task is being canceled...')
                    : ElevatedButton(
                      onPressed: cancelTask,
                      child: const Text('Cancel Task'),
                    ),
              if (progressText != null) Text(progressText!),
              isLoading
                  ? const CircularProgressIndicator()
                  : videoUrl != null
                  ? _videoPlayerController != null &&
                          _videoPlayerController!.value.isInitialized
                      ? AspectRatio(
                        aspectRatio: _videoPlayerController!.value.aspectRatio,
                        child: VideoPlayer(_videoPlayerController!),
                      )
                      : Text(videoUrl ?? '')
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
