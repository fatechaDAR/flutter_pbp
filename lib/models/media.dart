// lib/models/media.dart

abstract class Media {
  // Properti dibuat private (hanya bisa diakses di dalam class ini)
  final String _judul;
  final int _tahunRilis;
  final String _genre;
  final String? _urlGambar; // Opsional, bisa null

  // Konstruktor
  Media(this._judul, this._tahunRilis, this._genre, this._urlGambar);

  // Getter publik untuk mengakses properti private dari luar
  String get judul => _judul;
  int get tahunRilis => _tahunRilis;
  String get genre => _genre;
  String? get urlGambar => _urlGambar;
}