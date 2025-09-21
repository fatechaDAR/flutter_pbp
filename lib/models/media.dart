// lib/models/media.dart

// BARU: Tambahkan import untuk setiap kelas anak
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

  Media(this._judul, this._tahunRilis, this._genre, this._urlGambar,
      {StatusProgress status = StatusProgress.Belum})
      : _status = status;

  String get judul => _judul;
  int get tahunRilis => _tahunRilis;
  String get genre => _genre;
  String? get urlGambar => _urlGambar;
  StatusProgress get status => _status;
  set status(StatusProgress statusbaru) => _status = statusbaru;

  Map<String, dynamic> toJson();

  factory Media.fromJson(Map<String, dynamic> map) {
    // Sekarang bagian ini tidak akan error karena sudah di-import
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