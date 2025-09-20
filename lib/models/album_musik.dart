// lib/models/album_musik.dart

import 'media.dart';

class AlbumMusik extends Media {
  final String _artis;
  final int _jumlahLagu;

  AlbumMusik(
    String judul,
    int tahunRilis,
    String genre,
    String? urlGambar,
    this._artis,
    this._jumlahLagu,
  ) : super(judul, tahunRilis, genre, urlGambar);

  String get artis => _artis;
  int get jumlahLagu => _jumlahLagu;
}