// File ini hanya berisi kerangka dasar/induk dari sebuah Tugas.
abstract class Tugas {
  String judul;
  bool isSelesai;

  Tugas({required this.judul, this.isSelesai = false});
}