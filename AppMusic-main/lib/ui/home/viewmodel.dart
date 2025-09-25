import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../data/model/song.dart';

class MusicAppViewModel {
  final StreamController<List<Song>> songStream = StreamController.broadcast();
  List<Song> _songs = [];

  /// Load danh sách bài hát từ file JSON
  Future<void> loadSongs() async {
    final data = await rootBundle.loadString('assets/songs.json');
    final List<dynamic> jsonResult = json.decode(data);
    _songs = jsonResult.map((e) => Song.fromJson(e)).toList();
    songStream.add(_songs);
  }

  /// Lấy danh sách tất cả bài hát
  List<Song> getAllSongs() => _songs;

  /// Toggle trạng thái yêu thích
  void toggleFavorite(Song song) {
    final index = _songs.indexWhere((s) => s.id == song.id);
    if (index != -1) {
      _songs[index].isFavorite = !_songs[index].isFavorite;
      songStream.add(_songs); // update stream
    }
  }

  /// Lấy danh sách bài hát yêu thích
  List<Song> getFavoriteSongs() {
    return _songs.where((s) => s.isFavorite).toList();
  }

  void dispose() {
    songStream.close();
  }
}
