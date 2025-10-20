import 'media.dart';

class AlbumMusik extends Media {
  final String _artis;
  final int _jumlahLagu;

  AlbumMusik(
    String judul,
    int tahun,
    List<String> genres,
    String? url,
    this._artis,
    this._jumlahLagu, {
    StatusProgress status = StatusProgress.Belum,
    bool isFavorit = false, 
  }) : super(judul, tahun, genres, url, status: status, isFavorit: isFavorit);

  String get artis => _artis;
  int get jumlahLagu => _jumlahLagu;
  
  @override
  Map<String, dynamic> toJson() => {
        'type': 'album_musik',
        'judul': judul,
        'tahunRilis': tahunRilis,
  'genre': genre,
  'genres': genres,
        'urlGambar': urlGambar,
        'status': status.name,
        'isFavorit': isFavorit, 
        'artis': _artis,
        'jumlahLagu': _jumlahLagu,
      };

  factory AlbumMusik.fromJson(Map<String, dynamic> map) {
    List<String> genres;
    if (map.containsKey('genres') && map['genres'] is List) {
      genres = List<String>.from(map['genres']);
    } else if (map.containsKey('genre') && map['genre'] is String) {
      genres = [(map['genre'] as String)];
    } else {
      genres = [];
    }

    return AlbumMusik(
      map['judul'],
      map['tahunRilis'],
      genres,
      map['urlGambar'],
      map['artis'],
      map['jumlahLagu'],
      status: StatusProgress.values.byName(map['status']),
      isFavorit: map['isFavorit'] ?? false, 
    );
  }
}