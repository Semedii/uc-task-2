import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/services.dart';

class PlayerScreen extends HookWidget {
  final String videoUrl;
  final String title;

  const PlayerScreen({super.key, required this.videoUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized<BetterPlayerController>(() {
      final dataSource = BetterPlayerDataSource.network(
        videoUrl,
        videoFormat: BetterPlayerVideoFormat.other,
      );

      return BetterPlayerController(
        BetterPlayerConfiguration(
          autoPlay: true,
          looping: false,
          fit: BoxFit.contain,
          aspectRatio: 16 / 9,
          handleLifecycle: true,
          fullScreenByDefault: false,

          errorBuilder: (context, errorMessage) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'Playback error: $errorMessage',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },

          controlsConfiguration: BetterPlayerControlsConfiguration(
            enablePlayPause: true,
            enableMute: true,
            enableFullscreen: true,
            enableSkips: true,
            enableOverflowMenu: true,
            enableProgressBar: true,
            enableProgressBarDrag: true,
            enableSubtitles: false,
            controlBarColor: Colors.black54,
            controlBarHeight: 50,
            loadingWidget: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
        ),
        betterPlayerDataSource: dataSource,
      );
    });

    useEffect(() {
      void onFullscreenChanged() {
        if (controller.isFullScreen) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        } else {
          SystemChrome.setPreferredOrientations(DeviceOrientation.values);
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        }
      }

      controller.addEventsListener((event) {
        if (event.betterPlayerEventType ==
                BetterPlayerEventType.openFullscreen ||
            event.betterPlayerEventType ==
                BetterPlayerEventType.hideFullscreen) {
          onFullscreenChanged();
        }
      });

      return () {
        controller.dispose();
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      };
    }, [controller]);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return SafeArea(
            minimum: orientation == Orientation.landscape
                ? EdgeInsets.zero
                : EdgeInsets.zero,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(controller: controller),
            ),
          );
        },
      ),
    );
  }
}
