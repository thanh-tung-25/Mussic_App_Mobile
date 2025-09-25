import 'package:flutter/material.dart';
import '../../data/model/song.dart';
import '../home/viewmodel.dart';

class FavoriteTab extends StatelessWidget {
  final MusicAppViewModel viewModel;

  const FavoriteTab({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final favSongs = viewModel.getFavoriteSongs();

    if (favSongs.isEmpty) {
      return const Center(child: Text("Chưa có bài hát yêu thích"));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Danh sách yêu thích")),
      body: ListView.builder(
        itemCount: favSongs.length,
        itemBuilder: (context, index) {
          final song = favSongs[index];
          return ListTile(
            leading: Image.network(song.image, width: 40, height: 40, fit: BoxFit.cover),
            title: Text(song.title),
            subtitle: Text("${song.artist} • ${song.album}"),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.red),
              onPressed: () => viewModel.toggleFavorite(song),
            ),
          );
        },
      ),
    );
  }
}
