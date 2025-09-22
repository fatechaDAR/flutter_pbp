import 'media.dart';

class AlbumMusik extends Media {
  final String _artis;
  final int _jumlahLagu;

  AlbumMusik(
    String judul,
    int tahun,
    String genre,
    String? url,
    this._artis,
    this._jumlahLagu, {
    StatusProgress status = StatusProgress.Belum,
    bool isFavorit = false, 
  }) : super(judul, tahun, genre, url, status: status, isFavorit: isFavorit); // DIUBAH

  String get artis => _artis;
  int get jumlahLagu => _jumlahLagu;
  
  @override
  Map<String, dynamic> toJson() => {
        'type': 'album_musik',
        'judul': judul,
        'tahunRilis': tahunRilis,
        'genre': genre,
        'urlGambar': urlGambar,
        'status': status.name,
        'isFavorit': isFavorit, 
        'artis': _artis,
        'jumlahLagu': _jumlahLagu,
      };

  factory AlbumMusik.fromJson(Map<String, dynamic> map) {
    return AlbumMusik(
      map['judul'],
      map['tahunRilis'],
      map['genre'],
      map['urlGambar'],
      map['artis'],
      map['jumlahLagu'],
      status: StatusProgress.values.byName(map['status']),
      isFavorit: map['isFavorit'] ?? false, 
    );
  }
}