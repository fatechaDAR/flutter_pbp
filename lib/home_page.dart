// lib/home_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Class Model untuk data Tugas
class Tugas {
  String judul;
  bool isSelesai;

  Tugas({required this.judul, this.isSelesai = false});

  // Fungsi untuk mengubah objek Tugas menjadi format yang bisa disimpan (JSON)
  Map<String, dynamic> toJson() => {
        'judul': judul,
        'isSelesai': isSelesai,
      };

  // Fungsi untuk membuat objek Tugas dari data yang tersimpan (JSON)
  factory Tugas.fromJson(Map<String, dynamic> map) {
    return Tugas(
      judul: map['judul'],
      isSelesai: map['isSelesai'],
    );
  }
}

// Mengubah HomePage menjadi StatefulWidget agar bisa mengelola data
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variabel untuk menampung daftar tugas
  final List<Tugas> _daftarTugas = [];
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Panggil fungsi _loadTugas saat halaman pertama kali dibuka
    _loadTugas();
  }

  // Fungsi untuk MEMUAT data dari memori perangkat
  Future<void> _loadTugas() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tugasString = prefs.getString('list_tugas');
    if (tugasString != null) {
      final List<dynamic> tugasJson = jsonDecode(tugasString);
      setState(() {
        _daftarTugas.clear();
        _daftarTugas.addAll(tugasJson.map((json) => Tugas.fromJson(json)));
      });
    }
  }

  // Fungsi untuk MENYIMPAN data ke memori perangkat
  Future<void> _saveTugas() async {
    final prefs = await SharedPreferences.getInstance();
    final String tugasString =
        jsonEncode(_daftarTugas.map((tugas) => tugas.toJson()).toList());
    await prefs.setString('list_tugas', tugasString);
  }

  // Fungsi untuk menambah tugas baru
  void _tambahTugas(String judul) {
    setState(() {
      _daftarTugas.add(Tugas(judul: judul));
    });
    _saveTugas(); // Simpan perubahan
  }

  // Fungsi untuk mengubah status selesai
  void _ubahStatusTugas(int index) {
    setState(() {
      _daftarTugas[index].isSelesai = !_daftarTugas[index].isSelesai;
    });
    _saveTugas(); // Simpan perubahan
  }

  // Fungsi untuk menghapus tugas
  void _hapusTugas(int index) {
    setState(() {
      _daftarTugas.removeAt(index);
    });
    _saveTugas(); // Simpan perubahan
  }
  
  // Fungsi untuk menampilkan dialog tambah tugas
  void _tampilkanDialogTambahTugas() {
    // Pastikan controller bersih sebelum dialog ditampilkan
    _textController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Tugas Baru'),
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
                  _tambahTugas(_textController.text);
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
        title: const Text('To-Do List'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: _daftarTugas.length,
        itemBuilder: (context, index) {
          final tugas = _daftarTugas[index];
          return ListTile(
            leading: Checkbox(
              value: tugas.isSelesai,
              onChanged: (value) {
                _ubahStatusTugas(index);
              },
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
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red.shade400),
              onPressed: () {
                _hapusTugas(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tampilkanDialogTambahTugas,
        tooltip: 'Tambah Tugas',
        child: const Icon(Icons.add),
      ),
    );
  }
}