// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MusicWidget());
}

class MusicWidget extends StatefulWidget {
  @override
  _MusicWidgetState createState() => _MusicWidgetState();
}

class _MusicWidgetState extends State<MusicWidget> {
  final player = AudioPlayer();
  bool isPlaying = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  int currentTrack = 1;

  @override
  void initState() {
    super.initState();
    player.onPositionChanged.listen((position) {
      setState(() {
        currentPosition = position;
      });
    });
    player.onDurationChanged.listen((duration) {
      setState(() {
        totalDuration = duration;
      });
    });
  }

  Future<void> playMusic(int mn) async {
    setState(() {
      currentTrack = mn;
      isPlaying = true;
    });
    await player.setSource(AssetSource('music$mn.mp3'));
    await player.resume();
  }

  Future<void> pauseMusic() async {
    await player.pause();
    setState(() {
      isPlaying = false;
    });
  }

  Future<void> resumeMusic() async {
    await player.resume();
    setState(() {
      isPlaying = true;
    });
  }

  Future<void> seekMusic(Duration position) async {
    await player.seek(position);
  }

  Expanded myButton({required int mn, required Color bC, required String bT}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              currentTrack == mn ? Colors.grey[300]! : Colors.white,
            ),
          ),
          onPressed: () async {
            await playMusic(mn);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.music_note,
                  color: bC,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  bT,
                  style: TextStyle(
                    color: bC,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      home: Scaffold(
        backgroundColor: Colors.purple[300],
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: const Text('Music App'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(8.0),
                children: [
                  myButton(mn: 1, bC: Colors.red, bT: 'Mosaique'),
                  myButton(mn: 2, bC: Colors.green, bT: 'fire'),
                  myButton(mn: 3, bC: Colors.black, bT: 'palestine'),
                  myButton(mn: 4, bC: Colors.orange, bT: 'Galbi'),
                  myButton(mn: 5, bC: Colors.blue, bT: 'In your Corner'),
                  myButton(mn: 6, bC: Colors.purple, bT: 'Demain cest b3id'),
                  myButton(mn: 7, bC: Colors.grey, bT: 'Love natural'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Slider(
                    value: currentPosition.inSeconds.toDouble(),
                    max: totalDuration.inSeconds.toDouble(),
                    onChanged: (value) async {
                      await seekMusic(Duration(seconds: value.toInt()));
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatDuration(currentPosition)),
                      Text(formatDuration(totalDuration)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.skip_previous),
                        onPressed: () {
                          if (currentTrack > 1) {
                            playMusic(currentTrack - 1);
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                        onPressed: () {
                          if (isPlaying) {
                            pauseMusic();
                          } else {
                            resumeMusic();
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next),
                        onPressed: () {
                          if (currentTrack < 7) {
                            playMusic(currentTrack + 1);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
