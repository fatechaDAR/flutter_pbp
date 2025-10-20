// lib/models/media.dart

import 'film.dart';
import 'buku.dart';
import 'album_musik.dart';

enum StatusProgress { Belum, Sedang, Selesai }

abstract class Media {
  final String _judul;
  final int _tahunRilis;
  final List<String> _genres;
  final String? _urlGambar;
  StatusProgress _status;
  bool _isFavorit; 

  
  Media(this._judul, this._tahunRilis, this._genres, this._urlGambar,
      {StatusProgress status = StatusProgress.Belum,
      bool isFavorit = false})
      : _status = status,
        _isFavorit = isFavorit;

  
  String get judul => _judul;
  int get tahunRilis => _tahunRilis;
  // Backward-compatible convenience getter: join genres into a single string
  String get genre => _genres.join(', ');
  List<String> get genres => _genres;
  String? get urlGambar => _urlGambar;
  StatusProgress get status => _status;
  set status(StatusProgress statusbaru) => _status = statusbaru;

  
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