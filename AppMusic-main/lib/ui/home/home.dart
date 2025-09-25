import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Các file con
import 'package:my_app/ui/discovery/discovery.dart';
import 'package:my_app/ui/home/viewmodel.dart';
import 'package:my_app/ui/now_playing/audio_player_manager.dart';
import 'package:my_app/ui/now_playing/MiniPlayer.dart';
import 'package:my_app/ui/settings/settings.dart';
import 'package:my_app/ui/user/user.dart';
import 'package:my_app/ui/now_playing/playing.dart';
import '../../data/model/song.dart';

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MusicHomePage(),
    );
  }
}

/// ---------------------
/// Màn hình chính
/// ---------------------
class MusicHomePage extends StatelessWidget {
  const MusicHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      const HomeTab(),
      const DiscoveryTab(),
      const FavoriteTab(),
      const AccountTab(),
      const SettingsPage(),
    ];

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Thư viện',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.music_note_list),
            label: 'Khám phá',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart),
            label: 'Yêu thích',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Cá nhân',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Cài đặt',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) => tabs[index],
        );
      },
    );
  }
}

/// ---------------------
/// Tab Thư viện (Home)
/// ---------------------
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeTabPage();
  }
}

class _HomeTabPage extends StatefulWidget {
  const _HomeTabPage({super.key});

  @override
  State<_HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<_HomeTabPage> {
  List<Song> songs = [];
  List<Song> favoriteSongs = [];
  late MusicAppViewModel _viewModel;

  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _viewModel = MusicAppViewModel();
    _viewModel.loadSongs();
    observeData();
  }

  void observeData() {
    _viewModel.songStream.stream.listen((songList) {
      if (!mounted) return;
      setState(() {
        songs = List.from(songList);
      });
    });
  }

  @override
  void dispose() {
    _viewModel.songStream.close();
    AudioPlayerManager().dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (songs.isEmpty) {
      return const Center(child: CupertinoActivityIndicator());
    }

    final filteredSongs = songs.where((song) {
      final query = _searchQuery.trim().toLowerCase();
      return song.title.toLowerCase().contains(query) ||
          song.artist.toLowerCase().contains(query);
    }).toList();

    return CupertinoPageScaffold(
      navigationBar: _buildNavigationBar(),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: filteredSongs.isEmpty
                  ? const Center(child: Text("Không tìm thấy bài hát"))
                  : ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => _SongItemSection(
                  parent: this,
                  song: filteredSongs[index],
                ),
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey,
                  thickness: 1,
                  indent: 24,
                  endIndent: 24,
                ),
                itemCount: filteredSongs.length,
              ),
            ),
            ValueListenableBuilder<Song?>(
              valueListenable: AudioPlayerManager().currentSongNotifier,
              builder: (context, song, _) {
                if (song != null) return MiniPlayer(song: song);
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  CupertinoNavigationBar _buildNavigationBar() {
    return CupertinoNavigationBar(
      backgroundColor: Colors.white,
      middle: !_isSearching
          ? const Text(
        "Danh sách bài hát",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      )
          : null,
      leading: _isSearching
          ? SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: CupertinoSearchTextField(
          controller: _searchController,
          autofocus: true,
          placeholder: "Tìm kiếm bài hát...",
          onChanged: (value) {
            setState(() => _searchQuery = value);
          },
          onSuffixTap: () {
            setState(() {
              _isSearching = false;
              _searchQuery = "";
              _searchController.clear();
            });
          },
        ),
      )
          : null,
      trailing: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          setState(() {
            _isSearching = !_isSearching;
            if (!_isSearching) {
              _searchQuery = "";
              _searchController.clear();
            }
          });
        },
        child: Icon(
          _isSearching ? CupertinoIcons.xmark_circle : CupertinoIcons.search,
          color: CupertinoColors.label,
          size: 20,
        ),
      ),
    );
  }

  void showBottomSheet(Song song) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text("Options"),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                if (!favoriteSongs.contains(song)) favoriteSongs.add(song);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Đã thêm vào Yêu thích")),
              );
            },
            child: const Text("Thêm vào Yêu thích"),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text("Add to Playlist"),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text("Share"),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text("Delete"),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
      ),
    );
  }

  void navigate(Song song) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => NowPlaying(songs: songs, playingSong: song),
      ),
    );
  }
}

/// ---------------------
/// Tab Yêu thích
/// ---------------------
class FavoriteTab extends StatelessWidget {
  const FavoriteTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FavoriteTabPage();
  }
}

class _FavoriteTabPage extends StatefulWidget {
  const _FavoriteTabPage({super.key});

  @override
  State<_FavoriteTabPage> createState() => _FavoriteTabPageState();
}

class _FavoriteTabPageState extends State<_FavoriteTabPage> {
  List<Song> favoriteSongs = [];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Yêu thích"),
      ),
      child: SafeArea(
        child: favoriteSongs.isEmpty
            ? const Center(child: Text("Chưa có bài hát yêu thích"))
            : ListView.builder(
          itemCount: favoriteSongs.length,
          itemBuilder: (context, index) {
            final song = favoriteSongs[index];
            return ListTile(
              leading: Image.network(song.image,
                  width: 50, height: 50, fit: BoxFit.cover),
              title: Text(song.title),
              subtitle: Text(song.artist),
            );
          },
        ),
      ),
    );
  }
}

/// ---------------------
/// Item hiển thị bài hát
/// ---------------------
class _SongItemSection extends StatelessWidget {
  const _SongItemSection({required this.parent, required this.song});

  final _HomeTabPageState parent;
  final Song song;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final audioManager = AudioPlayerManager();
        audioManager.setPlaylist(
          parent.songs,
          startIndex: parent.songs.indexOf(song),
        );
        await audioManager.player.setUrl(song.source);
        parent.navigate(song);
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/FaviconSHOP.png',
                image: song.image,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) =>
                    Image.asset('assets/FaviconSHOP.png',
                        width: 56, height: 56, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.label,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song.artist,
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => parent.showBottomSheet(song),
              child: const Icon(
                CupertinoIcons.ellipsis,
                size: 22,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}