// lib/models/media.dart

import 'film.dart';
import 'buku.dart';
import 'album_musik.dart';

enum StatusProgress { Belum, Sedang, Selesai }

abstract class Media {
  final String _judul;
  final int _tahunRilis;
  final String _genre;
  final String? _urlGambar;
  StatusProgress _status;
  bool _isFavorit; // BARU: Properti untuk favorit

  // DIUBAH: Tambahkan isFavorit di konstruktor
  Media(this._judul, this._tahunRilis, this._genre, this._urlGambar,
      {StatusProgress status = StatusProgress.Belum,
      bool isFavorit = false})
      : _status = status,
        _isFavorit = isFavorit;

  // ... getter & setter yang sudah ada
  String get judul => _judul;
  int get tahunRilis => _tahunRilis;
  String get genre => _genre;
  String? get urlGambar => _urlGambar;
  StatusProgress get status => _status;
  set status(StatusProgress statusbaru) => _status = statusbaru;

  // BARU: Getter dan method untuk favorit
  bool get isFavorit => _isFavorit;
  void toggleFavorit() {
    _isFavorit = !_isFavorit;
  }

  Map<String, dynamic> toJson();

  factory Media.fromJson(Map<String, dynamic> map) {
    switch (map['type']) {
      case 'film':
        return Film.fromJson(map);
      case 'buku':
        return Buku.fromJson(map);
      case 'album_musik':
        return AlbumMusik.fromJson(map);
      default:
        throw Exception('Tipe media tidak dikenal: ${map['type']}');
    }
  }
}