import 'media.dart';

class AlbumMusik extends Media {
  final String _artis;
  final int _jumlahLagu;
  final String _genre; // single genre for album

  AlbumMusik(
    String judul,
    int tahun,
    String genre,
    String? url,
    this._artis,
    this._jumlahLagu, {
    StatusProgress status = StatusProgress.Belum,
    bool isFavorit = false,
  }) : _genre = genre,
       super(judul, tahun, <String>[], url, status: status, isFavorit: isFavorit);

  String get artis => _artis;
  int get jumlahLagu => _jumlahLagu;

  @override
  // override to return single genre string
  String get genre => _genre;

  @override
  Map<String, dynamic> toJson() => {
        'type': 'album_musik',
        'judul': judul,
        'tahunRilis': tahunRilis,
        'genre': _genre,
        'urlGambar': urlGambar,
        'status': status.name,
        'isFavorit': isFavorit,
        'artis': _artis,
        'jumlahLagu': _jumlahLagu,
      };

  factory AlbumMusik.fromJson(Map<String, dynamic> map) {
    // Backward compatibility: if 'genres' provided, take first as album genre
    String genre = '';
    if (map.containsKey('genre') && map['genre'] is String) {
      genre = map['genre'];
    } else if (map.containsKey('genres') && map['genres'] is List && (map['genres'] as List).isNotEmpty) {
      genre = (map['genres'] as List).first.toString();
    }

    return AlbumMusik(
      map['judul'],
      map['tahunRilis'],
      genre,
      map['urlGambar'],
      map['artis'],
      map['jumlahLagu'],
      status: StatusProgress.values.byName(map['status']),
      isFavorit: map['isFavorit'] ?? false,
    );
  }
}