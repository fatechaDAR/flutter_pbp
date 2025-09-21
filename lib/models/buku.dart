import 'media.dart';

class Buku extends Media {
  final String _penulis;
  final int _jumlahHalaman;
  String _catatanPribadi;

  Buku(String judul, int tahun, String genre, String? url, this._penulis,
      this._jumlahHalaman,
      {String catatan = '', StatusProgress status = StatusProgress.Belum})
      : _catatanPribadi = catatan,
        super(judul, tahun, genre, url, status: status);

  String get penulis => _penulis;
  int get jumlahHalaman => _jumlahHalaman;
  String get catatanPribadi => _catatanPribadi;
  set catatanPribadi(String catatan) => _catatanPribadi = catatan;
  
  @override
  Map<String, dynamic> toJson() => {
        'type': 'buku',
        // DIUBAH: Gunakan getter publik
        'judul': judul,
        'tahunRilis': tahunRilis,
        'genre': genre,
        'urlGambar': urlGambar,
        'status': status.name,
        'penulis': _penulis,
        'jumlahHalaman': _jumlahHalaman,
        'catatanPribadi': _catatanPribadi,
      };

  factory Buku.fromJson(Map<String, dynamic> map) {
    return Buku(
      map['judul'], map['tahunRilis'], map['genre'], map['urlGambar'],
      map['penulis'], map['jumlahHalaman'],
      catatan: map['catatanPribadi'],
      status: StatusProgress.values.byName(map['status']),
    );
  }
}