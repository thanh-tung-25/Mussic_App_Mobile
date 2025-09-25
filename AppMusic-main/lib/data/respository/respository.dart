import 'package:my_app/data/source/source.dart';

import 'package:my_app/data/model/song.dart';

abstract interface class Repository {
  Future<List<Song>?> loadData();
}
class DefaultRepository implements Repository {
  final _localDataSource = LocalDataSource();
  final _remoteDateSource = RemoteDataSource();
  @override
  Future<List<Song>?> loadData() async {
    List<Song> songs =[];
    await _remoteDateSource.loadData().then((remoteSongs){
      if(remoteSongs == null){
        _localDataSource.loadData().then((localSongs){
          if(localSongs != null){
            songs.addAll(localSongs);
          }
        });
      } else {
        songs.addAll(remoteSongs);
      }
    });
    return songs;
  }
}