import 'media.dart';

class Film extends Media {
  final String _sutradara;
  final int _durasiMenit;
  double _ratingBintang;

  Film(String judul, int tahun, String genre, String? url, this._sutradara,
      this._durasiMenit,
      {double rating = 0.0, StatusProgress status = StatusProgress.Belum})
      : _ratingBintang = rating,
        super(judul, tahun, genre, url, status: status);

  String get sutradara => _sutradara;
  int get durasiMenit => _durasiMenit;
  double get ratingBintang => _ratingBintang;
  set ratingBintang(double rating) => _ratingBintang = rating;

  @override
  Map<String, dynamic> toJson() => {
        'type': 'film',
        // DIUBAH: Gunakan getter publik (tanpa '_') untuk properti dari Media
        'judul': judul,
        'tahunRilis': tahunRilis,
        'genre': genre,
        'urlGambar': urlGambar,
        'status': status.name,
        // Properti milik Film sendiri tetap bisa pakai '_'
        'sutradara': _sutradara,
        'durasiMenit': _durasiMenit,
        'ratingBintang': _ratingBintang,
      };

  factory Film.fromJson(Map<String, dynamic> map) {
    return Film(
      map['judul'], map['tahunRilis'], map['genre'], map['urlGambar'],
      map['sutradara'], map['durasiMenit'],
      rating: map['ratingBintang'],
      status: StatusProgress.values.byName(map['status']),
    );
  }
}