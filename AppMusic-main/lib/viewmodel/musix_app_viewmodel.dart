import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:my_app/data/model/song.dart';

class MusicAppViewModel {
  final songStream = StreamController<List<Song>>.broadcast(); // broadcast để tránh lỗi listen nhiều lần

  /// Load dữ liệu từ file JSON
  Future<void> loadSongs() async {
    try {
      final String data = await rootBundle.loadString('assets/songs.json');
      final jsonResult = json.decode(data) as Map<String, dynamic>;
      final songListJson = jsonResult['songs'] as List<dynamic>;
      final songs = songListJson.map((e) => Song.fromJson(e)).toList();

      songStream.add(songs); // push vào stream
    } catch (e) {
      print("❌ Lỗi load songs: $e");
      songStream.add([]); // nếu lỗi thì gửi list rỗng
    }
  }

  void dispose() {
    songStream.close();
  }
}
