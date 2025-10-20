import 'media.dart';

class Film extends Media {
  final String _sutradara;
  final int _durasiMenit;
  double _ratingBintang;

  Film(
    String judul,
    int tahun,
    List<String> genres,
    String? url,
    this._sutradara,
    this._durasiMenit, {
    double rating = 0.0,
    StatusProgress status = StatusProgress.Belum,
    bool isFavorit = false, 
  })  : _ratingBintang = rating,
        super(judul, tahun, genres, url, status: status, isFavorit: isFavorit); 

  String get sutradara => _sutradara;
  int get durasiMenit => _durasiMenit;
  double get ratingBintang => _ratingBintang;
  set ratingBintang(double rating) => _ratingBintang = rating;

  @override
  Map<String, dynamic> toJson() => {
        'type': 'film',
        'judul': judul,
        'tahunRilis': tahunRilis,
  'genre': genre,
  'genres': genres,
        'urlGambar': urlGambar,
        'status': status.name,
        'isFavorit': isFavorit, 
        'sutradara': _sutradara,
        'durasiMenit': _durasiMenit,
        'ratingBintang': _ratingBintang,
      };

  factory Film.fromJson(Map<String, dynamic> map) {
    // Backward compatibility: 'genre' can be a single string or 'genres' a list
    List<String> genres;
    if (map.containsKey('genres') && map['genres'] is List) {
      genres = List<String>.from(map['genres']);
    } else if (map.containsKey('genre') && map['genre'] is String) {
      genres = [(map['genre'] as String)];
    } else {
      genres = [];
    }

    return Film(
      map['judul'],
      map['tahunRilis'],
      genres,
      map['urlGambar'],
      map['sutradara'],
      map['durasiMenit'],
      rating: map['ratingBintang'],
      status: StatusProgress.values.byName(map['status']),
      isFavorit: map['isFavorit'] ?? false,
    );
  }
}