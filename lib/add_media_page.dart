// lib/add_media_page.dart

import 'package:flutter/material.dart';
import 'models/media.dart';
import 'models/film.dart';
import 'models/buku.dart';
import 'models/album_musik.dart';

enum TipeMedia { Film, Buku, AlbumMusik }

class AddMediaPage extends StatefulWidget {
  const AddMediaPage({super.key});

  @override
  State<AddMediaPage> createState() => _AddMediaPageState();
}

class _AddMediaPageState extends State<AddMediaPage> {
  final _formKey = GlobalKey<FormState>();
  TipeMedia _tipeMedia = TipeMedia.Film;

  // Controllers untuk data umum
  final _judulController = TextEditingController();
  final _tahunController = TextEditingController();
  final _genreController = TextEditingController();

  // Controllers untuk data spesifik
  final _sutradaraController = TextEditingController();
  final _durasiController = TextEditingController();
  final _penulisController = TextEditingController();
  final _halamanController = TextEditingController();
  final _artisController = TextEditingController();
  final _laguController = TextEditingController();

  void _simpanForm() {
    if (_formKey.currentState!.validate()) {
      Media? mediaBaru;
      final judul = _judulController.text;
      final tahun = int.parse(_tahunController.text);
      final genre = _genreController.text;

      switch (_tipeMedia) {
        case TipeMedia.Film:
          mediaBaru = Film(judul, tahun, genre, null, _sutradaraController.text,
              int.parse(_durasiController.text));
          break;
        case TipeMedia.Buku:
          mediaBaru = Buku(judul, tahun, genre, null, _penulisController.text,
              int.parse(_halamanController.text));
          break;
        case TipeMedia.AlbumMusik:
          mediaBaru = AlbumMusik(judul, tahun, genre, null,
              _artisController.text, int.parse(_laguController.text));
          break;
      }
      // Kirim data baru kembali ke HomePage
      Navigator.pop(context, mediaBaru);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Media Baru'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<TipeMedia>(
                value: _tipeMedia,
                decoration: const InputDecoration(labelText: 'Tipe Media'),
                items: TipeMedia.values
                    .map((tipe) => DropdownMenuItem(
                          value: tipe,
                          child: Text(tipe.name),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _tipeMedia = value!;
                  });
                },
              ),
              TextFormField(
                  controller: _judulController,
                  decoration: const InputDecoration(labelText: 'Judul')),
              TextFormField(
                  controller: _tahunController,
                  decoration: const InputDecoration(labelText: 'Tahun Rilis'),
                  keyboardType: TextInputType.number),
              TextFormField(
                  controller: _genreController,
                  decoration: const InputDecoration(labelText: 'Genre')),
              
              if (_tipeMedia == TipeMedia.Film) ...[
                TextFormField(
                    controller: _sutradaraController,
                    decoration: const InputDecoration(labelText: 'Sutradara')),
                TextFormField(
                    controller: _durasiController,
                    decoration: const InputDecoration(labelText: 'Durasi (menit)'),
                    keyboardType: TextInputType.number),
              ] else if (_tipeMedia == TipeMedia.Buku) ...[
                TextFormField(
                    controller: _penulisController,
                    decoration: const InputDecoration(labelText: 'Penulis')),
                TextFormField(
                    controller: _halamanController,
                    decoration: const InputDecoration(labelText: 'Jumlah Halaman'),
                    keyboardType: TextInputType.number),
              ] else if (_tipeMedia == TipeMedia.AlbumMusik) ...[
                TextFormField(
                    controller: _artisController,
                    decoration: const InputDecoration(labelText: 'Artis')),
                TextFormField(
                    controller: _laguController,
                    decoration: const InputDecoration(labelText: 'Jumlah Lagu'),
                    keyboardType: TextInputType.number),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _simpanForm,
                child: const Text('Simpan'),
              )
            ],
          ),
        ),
      ),
    );
  }
}