// lib/models/buku.dart

import 'media.dart';

class Buku extends Media {
  final String _penulis;
  String _catatanPribadi;
  int _halamanDibaca; // Properti untuk halaman yang sudah dibaca

  Buku(
    String judul,
    int tahun,
    List<String> genres,
    String? url,
    this._penulis, {
    String catatan = '',
    StatusProgress status = StatusProgress.Belum,
    bool isFavorit = false,
    int halamanDibaca = 0,
  })  : _catatanPribadi = catatan,
        _halamanDibaca = halamanDibaca,
        super(judul, tahun, genres, url, status: status, isFavorit: isFavorit) {
    // Tidak ada batasan atas karena kita tidak lagi menyimpan jumlah total halaman
    assert(halamanDibaca >= 0, 'Halaman yang dibaca harus bernilai >= 0');
  }

  // Getters
  String get penulis => _penulis;
  String get catatanPribadi => _catatanPribadi;
  int get halamanDibaca => _halamanDibaca;

  // Setters
  set catatanPribadi(String catatan) => _catatanPribadi = catatan;
  set halamanDibaca(int dibaca) {
    assert(dibaca >= 0, 'Halaman yang dibaca harus valid (>= 0)');
    _halamanDibaca = dibaca;
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': 'buku',
        'judul': judul,
        'tahunRilis': tahunRilis,
    'genre': genre,
    'genres': genres,
        'urlGambar': urlGambar,
        'status': status.name,
        'isFavorit': isFavorit,
        'penulis': _penulis,
        'catatanPribadi': _catatanPribadi,
        'halamanDibaca': _halamanDibaca,
      };

  factory Buku.fromJson(Map<String, dynamic> map) {
    List<String> genres;
    if (map.containsKey('genres') && map['genres'] is List) {
      genres = List<String>.from(map['genres']);
    } else if (map.containsKey('genre') && map['genre'] is String) {
      genres = [(map['genre'] as String)];
    } else {
      genres = [];
    }

    return Buku(
      map['judul'],
      map['tahunRilis'],
      genres,
      map['urlGambar'],
      map['penulis'],
      catatan: map['catatanPribadi'] ?? '',
      status: StatusProgress.values.byName(map['status']),
      isFavorit: map['isFavorit'] ?? false,
      halamanDibaca: map['halamanDibaca'] ?? 0,
    );
  }
}