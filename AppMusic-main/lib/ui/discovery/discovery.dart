import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/data/model/song.dart';
import 'package:my_app/ui/now_playing/audio_player_manager.dart';
import 'package:my_app/ui/now_playing/playing.dart';
import 'package:my_app/ui/home/home.dart'; // có MusicAppViewModel
import 'package:my_app/viewmodel/musix_app_viewmodel.dart';

class DiscoveryTab extends StatefulWidget {
  const DiscoveryTab({super.key});

  @override
  State<DiscoveryTab> createState() => _DiscoveryTabState();
}

class _DiscoveryTabState extends State<DiscoveryTab> {
  List<Song> songs = [];
  late MusicAppViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = MusicAppViewModel();   // ✅ khởi tạo trước khi dùng
    _viewModel.loadSongs();
    _viewModel.songStream.stream.listen((songList) {
      setState(() {
        songs = songList; // cập nhật UI
      });
    });

  }

  void observeData() {
    _viewModel.songStream.stream.listen((songList) {
      setState(() {
        songs = songList; // dùng = để tránh trùng bài
      });
    });
  }

  @override
  void dispose() {
    _viewModel.songStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Khám phá 🎶"),
      ),
      child: SafeArea(
        child: songs.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => _SongCard(
            song: songs[index],
            playlist: songs,
          ),
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemCount: songs.length,
        ),
      ),
    );
  }
}

/// Widget hiển thị 1 bài hát dạng thẻ đẹp
class _SongCard extends StatelessWidget {
  final Song song;
  final List<Song> playlist;

  const _SongCard({required this.song, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final audioManager = AudioPlayerManager();
        audioManager.setPlaylist(playlist, startIndex: playlist.indexOf(song));
        await audioManager.player.setUrl(song.source);

        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => NowPlaying(songs: playlist, playingSong: song),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ảnh cover
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                song.image,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  "assets/FaviconSHOP.png",
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song.artist,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
