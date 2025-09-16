import 'tugas.dart';
class TugasDeadline extends Tugas {
  DateTime tanggalDeadline;

  TugasDeadline({required String judul, required this.tanggalDeadline})
      : super(judul: judul);
}