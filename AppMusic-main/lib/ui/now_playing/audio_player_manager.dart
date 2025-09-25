import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../../data/model/song.dart';
import 'package:my_app/ui/now_playing/audio_player_manager.dart';
import 'package:my_app/ui/now_playing/playing.dart';
import 'dart:math';
class AudioPlayerManager {

  AudioPlayerManager._internal();
  static final AudioPlayerManager _instance = AudioPlayerManager._internal();
  factory AudioPlayerManager() => _instance;

  Stream<DurationState>? durationState;
  String songUrl = "";
  final player = AudioPlayer();
  final currentSongNotifier = ValueNotifier<Song?>(null);
  List<Song> playlist = [];
  int currentIndex = 0;
  bool isShuffle = false;
  LoopMode loopMode = LoopMode.all;

  void prepare({bool isNewSong = false}){
    // Kết hợp positionStream và playbackEventStream
    durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
      player.positionStream,
      player.playbackEventStream,
          (position, playbackEvent) => DurationState(
        progress: position,
        buffered: playbackEvent.bufferedPosition,
        total: playbackEvent.duration,
      ),
    );
    if(isNewSong){
      player.setUrl(songUrl);
    }
  }

  void updateSongUrl(String url){
    songUrl = url;
    prepare();
  }
  void updateSong(Song song) async {
    if (currentSongNotifier.value?.source == song.source) {
      return;
    }
    songUrl = song.source;
    currentSongNotifier.value = song; // 🔔 notify MiniPlayer
    await player.setUrl(songUrl);
    player.play();
  }
  void setPlaylist(List<Song> songs, {int startIndex = 0}) {
    playlist = songs;
    currentIndex = startIndex;
    if (songs.isNotEmpty) {
      updateSong(songs[startIndex]);
    }
  }
  void playNext() {
    if (playlist.isEmpty) return;

    if (isShuffle) {
      final random = Random();
      currentIndex = random.nextInt(playlist.length);
    } else if (currentIndex < playlist.length - 1) {
      currentIndex++;
    } else if (loopMode == LoopMode.all) {
      currentIndex = 0;
    }

    final nextSong = playlist[currentIndex];
    updateSong(nextSong);
  }

  void playPrevious() {
    if (playlist.isEmpty) return;

    if (isShuffle) {
      final random = Random();
      currentIndex = random.nextInt(playlist.length);
    } else if (currentIndex > 0) {
      currentIndex--;
    } else if (loopMode == LoopMode.all) {
      currentIndex = playlist.length - 1;
    }

    final prevSong = playlist[currentIndex];
    updateSong(prevSong);
  }


  void dispose(){
    player.dispose();
  }
}

class DurationState {
  const DurationState({
    required this.progress,
    required this.buffered,
    this.total,
  });

  final Duration progress;
  final Duration buffered;
  final Duration? total;
}
