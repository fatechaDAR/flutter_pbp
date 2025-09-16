// lib/home_page.dart

import 'package.flutter/material.dart';
import 'models/tugas.dart';
import 'models/harian.dart';
import 'models/mingguan.dart'; 
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Tugas> _daftarTugas = [
    TugasHarian(judul: 'Menyapu lantai'),
    TugasDeadline(
      judul: 'Bayar tagihan listrik',
      tanggalDeadline: DateTime.now().add(const Duration(days: 3)),
    ),
    TugasHarian(judul: 'Mengerjakan tugas Flutter'),
  ];
  
  final TextEditingController _textController = TextEditingController();

  void _ubahStatusTugas(Tugas tugas) {
    setState(() {
      tugas.isSelesai = !tugas.isSelesai;
    });
  }

  void _hapusTugas(Tugas tugas) {
    setState(() {
      _daftarTugas.remove(tugas);
    });
  }

  void _tambahTugasHarian(String judul) {
    setState(() {
      _daftarTugas.add(TugasHarian(judul: judul));
    });
  }

  void _tampilkanDialogTambahTugas() {
    _textController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Tugas Harian Baru'),
          content: TextField(
            controller: _textController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Masukkan judul tugas...'),
          ),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Tambah'),
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  _tambahTugasHarian(_textController.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List (Multi-Tipe)'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: _daftarTugas.length,
        itemBuilder: (context, index) {
          final tugas = _daftarTugas[index];

          
          String subtitle = 'Tugas Harian'; 
          if (tugas is TugasDeadline) {
            
            subtitle = 'Deadline: ${DateFormat('d MMMM yyyy').format(tugas.tanggalDeadline)}';
          }
          
          return ListTile(
            leading: Checkbox(
              value: tugas.isSelesai,
              onChanged: (value) => _ubahStatusTugas(tugas),
            ),
            title: Text(
              tugas.judul,
              style: TextStyle(
                decoration: tugas.isSelesai
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: tugas.isSelesai ? Colors.grey[600] : Colors.black,
              ),
            ),
            // Tampilkan subtitle yang sudah kita siapkan
            subtitle: Text(subtitle),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red.shade400),
              onPressed: () => _hapusTugas(tugas),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tampilkanDialogTambahTugas,
        tooltip: 'Tambah Tugas Harian',
        child: const Icon(Icons.add),
      ),
    );
  }
}