// lib/models/buku.dart

import 'media.dart';

class Buku extends Media {
  final String _penulis;
  final int _jumlahHalaman;
  String _catatanPribadi;
  int _halamanDibaca; // BARU: Properti untuk halaman yang sudah dibaca

  Buku(
    String judul,
    int tahun,
    String genre,
    String? url,
    this._penulis,
    this._jumlahHalaman, {
    String catatan = '',
    StatusProgress status = StatusProgress.Belum,
    bool isFavorit = false,
    int halamanDibaca = 0, // BARU: Parameter halamanDibaca di konstruktor
  })  : _catatanPribadi = catatan,
        _halamanDibaca = halamanDibaca, // BARU: Inisialisasi _halamanDibaca
        super(judul, tahun, genre, url, status: status, isFavorit: isFavorit) {
    // Tambahkan assertion untuk memastikan halamanDibaca tidak melebihi total halaman
    assert(halamanDibaca <= _jumlahHalaman, 'Halaman yang dibaca tidak boleh melebihi jumlah halaman total');
  }

  // Getters
  String get penulis => _penulis;
  int get jumlahHalaman => _jumlahHalaman;
  String get catatanPribadi => _catatanPribadi;
  int get halamanDibaca => _halamanDibaca; // BARU: Getter untuk halamanDibaca

  // Setters (jika properti perlu diubah setelah pembuatan objek)
  set catatanPribadi(String catatan) => _catatanPribadi = catatan;
  set halamanDibaca(int dibaca) { // BARU: Setter untuk halamanDibaca
    assert(dibaca >= 0 && dibaca <= _jumlahHalaman, 'Halaman yang dibaca harus valid dan tidak melebihi total halaman');
    _halamanDibaca = dibaca;
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': 'buku',
        'judul': judul,
        'tahunRilis': tahunRilis,
        'genre': genre,
        'urlGambar': urlGambar,
        'status': status.name,
        'isFavorit': isFavorit,
        'penulis': _penulis,
        'jumlahHalaman': _jumlahHalaman,
        'catatanPribadi': _catatanPribadi,
        'halamanDibaca': _halamanDibaca, // BARU: Tambahkan ke JSON
      };

  factory Buku.fromJson(Map<String, dynamic> map) {
    return Buku(
      map['judul'],
      map['tahunRilis'],
      map['genre'],
      map['urlGambar'],
      map['penulis'],
      map['jumlahHalaman'],
      catatan: map['catatanPribadi'] ?? '', // Pastikan default string kosong
      status: StatusProgress.values.byName(map['status']),
      isFavorit: map['isFavorit'] ?? false,
      halamanDibaca: map['halamanDibaca'] ?? 0, // BARU: Ambil dari JSON, default 0
    );
  }
}