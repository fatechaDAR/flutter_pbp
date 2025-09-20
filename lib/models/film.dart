// lib/models/film.dart

import 'media.dart';

class Film extends Media {
  final String _sutradara;
  final int _durasiMenit;

  // Konstruktor Film memanggil konstruktor Media menggunakan 'super'
  Film(
    String judul,
    int tahunRilis,
    String genre,
    String? urlGambar,
    this._sutradara,
    this._durasiMenit,
  ) : super(judul, tahunRilis, genre, urlGambar);

  // Getter untuk properti tambahan
  String get sutradara => _sutradara;
  int get durasiMenit => _durasiMenit;
}