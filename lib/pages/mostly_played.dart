import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:m4m_app/provider/dark_mode.dart';
import 'package:provider/provider.dart';

import '../dataBase/functions/db_functions.dart';
import '../dataBase/models/songdb.dart';
import '../widgets/audio_view.dart';

class MostPlayed extends StatelessWidget {
  MostPlayed({super.key});

  final Box<List> playlistBox = getPlaylistBox();

  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

  @override
  Widget build(BuildContext context) {
    return Consumer<ViewModeState>(
      builder: (context, viewMode, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Most Played'),
            actions: [
              IconButton(
                onPressed: () {
                  viewMode.toggleViewMode();
                },
                icon: viewMode.viewIcon(),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ValueListenableBuilder(
              valueListenable: playlistBox.listenable(),
              builder: (context, value, _) {
                List<Songs> musicList = playlistBox
                    .get('MostPlayed')!
                    .reversed
                    .toList()
                    .cast<Songs>();
                if (musicList.isEmpty) {
                  return const Center(
                    child: Text(
                      'play what you like and find the most played songs here',
                    ),
                  );
                } else {
                  if (viewMode.isGridMode) {
                    return AudioGridView(
                      audiosList: musicList,
                      audioPlayer: audioPlayer,
                    );
                  } else {
                    return AudioTileView(
                      audiosList: musicList,
                      audioPlayer: audioPlayer,
                    );
                  }
                }
              },
            ),
          ),
        );
      },
    );
  }
}
