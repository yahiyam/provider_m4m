import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongAccessProvider extends ChangeNotifier {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final List<SongModel> sortedSongs = [];

  Future<void> accessSongs() async {
    final accessedSongs = await _audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    for (var song in accessedSongs) {
      sortedSongs.add(song);
    }
    // You can perform other operations with the sortedSongs list here
    // such as storing the songs in Hive or performing any necessary initialization.
    notifyListeners();
  }
}
