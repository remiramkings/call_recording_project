import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:call_recording_project/services/audio_player_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class CustomAudioPlayer extends StatefulWidget {
  String filePath;

  CustomAudioPlayer({super.key, required this.filePath});

  @override
  State<StatefulWidget> createState() {
    return CustomAudioPlayerState();
  }
}

class CustomAudioPlayerState extends State<CustomAudioPlayer> {
  AudioPlayerService audioService = AudioPlayerService.getInstance();

  Future<Duration?>? filePathFuture;
  Stream<Duration?>? progressStream;
  Stream<PlayerState>? playerStateStream;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  initializePlayer() {
    progressStream = audioService.getProgressStream();
    filePathFuture = audioService.setFilePath(widget.filePath);
    playerStateStream = audioService.player?.playerStateStream;
    playerStateStream!.listen((event) {
      if(event.processingState == ProcessingState.completed){
        audioService.play();
      }
    });
  }

  getFileNameFromPath() {
    return widget.filePath.split("/").last;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: FutureBuilder<Duration?>(
        future: filePathFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator.adaptive()),
            );
          }
          return Column(
            children: [
              Row(
                children: [
                  StreamBuilder<PlayerState>(
                      stream: playerStateStream,
                      builder: (context, playerStateSnapshot) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            (playerStateSnapshot.data != null
                              && playerStateSnapshot.data!.playing
                              && (playerStateSnapshot.data!.processingState == ProcessingState.loading
                                  || playerStateSnapshot .data!.processingState == ProcessingState.ready))
                                ? InkWell(
                                    child: const Icon(
                                      Icons.pause,
                                      size: 45,
                                      color: Colors.blue,
                                    ),
                                    onTap: () {
                                      audioService.player!
                                          .pause()
                                          .then((value) => {});
                                    },
                                  )
                                : InkWell(
                                    child:
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(Icons.play_arrow_outlined, size: 45,
                                          color: Colors.blue,
                                          ),
                                        ),
                                    onTap: () {
                                      if (!playerStateSnapshot.data!.playing &&
                                          playerStateSnapshot
                                                  .data!.processingState ==
                                              ProcessingState.ready) {
                                        audioService.play();
                                        return;
                                      }
                                      audioService.player!
                                          .seek(const Duration(seconds: 0))
                                          .then(
                                              (value) => {audioService.play()});
                                    },
                                  )
                          ],
                        );
                      }),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: StreamBuilder<Duration?>(
                      stream: progressStream,
                      builder: (context, streamSnap) {
                        Duration current = (streamSnap.data != null)
                            ? streamSnap.data!
                            : const Duration(seconds: 0);
                        Duration total = audioService.player!.duration ??
                            const Duration(seconds: 0);
                        return ProgressBar(
                          progress: current,
                          total: total,
                          onSeek: (duration) {
                            audioService.player!.seek(duration);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    if (audioService.player != null && audioService.player!.playing) {
      audioService.player!.dispose();
    }

    super.dispose();
  }
}
