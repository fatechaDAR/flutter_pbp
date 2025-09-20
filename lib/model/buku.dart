// lib/models/buku.dart

import 'media.dart';

class Buku extends Media {
  final String _penulis;
  final int _jumlahHalaman;

  Buku(
    String judul,
    int tahunRilis,
    String genre,
    String? urlGambar,
    this._penulis,
    this._jumlahHalaman,
  ) : super(judul, tahunRilis, genre, urlGambar);

  String get penulis => _penulis;
  int get jumlahHalaman => _jumlahHalaman;
}