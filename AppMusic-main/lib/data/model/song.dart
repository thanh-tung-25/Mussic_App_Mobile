class Song {
  final String id;
  final String title;
  final String artist;
  final String image;
  final String source; // thay cho url
  final String album;  // thêm field album
  bool isFavorite;     // ✅ thêm field isFavorite

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.image,
    required this.source,
    required this.album,
    this.isFavorite = false, // mặc định chưa yêu thích
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      image: json['image'] ?? '',
      source: json['source'] ?? json['url'] ?? '', // hỗ trợ cả url
      album: json['album'] ?? '',
      isFavorite: json['isFavorite'] ?? false, // ✅ đọc thêm field này
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'image': image,
      'source': source,
      'album': album,
      'isFavorite': isFavorite, // ✅ lưu thêm field này
    };
  }
}
