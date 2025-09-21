// lib/add_media_page.dart

import 'package:flutter/material.dart';
import 'models/media.dart';
import 'models/film.dart';
import 'models/buku.dart';
import 'models/album_musik.dart';

enum TipeMedia { Film, Buku, AlbumMusik }

class AddMediaPage extends StatefulWidget {
  final Media? mediaToEdit;
  const AddMediaPage({super.key, this.mediaToEdit});

  @override
  State<AddMediaPage> createState() => _AddMediaPageState();
}

class _AddMediaPageState extends State<AddMediaPage> {
  final _formKey = GlobalKey<FormState>();
  late TipeMedia _tipeMedia;
  bool get _isEditing => widget.mediaToEdit != null;

  // ... controllers umum
  final _judulController = TextEditingController();
  final _tahunController = TextEditingController();
  final _genreController = TextEditingController();
  // ... controllers spesifik
  final _sutradaraController = TextEditingController();
  final _durasiController = TextEditingController();
  final _penulisController = TextEditingController();
  final _halamanController = TextEditingController();
  final _artisController = TextEditingController();
  final _laguController = TextEditingController();
  // BARU: Controller & variabel untuk rating dan catatan
  final _catatanController = TextEditingController();
  double _rating = 0.0;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final media = widget.mediaToEdit!;
      _judulController.text = media.judul;
      _tahunController.text = media.tahunRilis.toString();
      _genreController.text = media.genre;

      if (media is Film) {
        _tipeMedia = TipeMedia.Film;
        _sutradaraController.text = media.sutradara;
        _durasiController.text = media.durasiMenit.toString();
        _rating = media.ratingBintang; // BARU
      } else if (media is Buku) {
        _tipeMedia = TipeMedia.Buku;
        _penulisController.text = media.penulis;
        _halamanController.text = media.jumlahHalaman.toString();
        _catatanController.text = media.catatanPribadi; // BARU
      } else if (media is AlbumMusik) {
        _tipeMedia = TipeMedia.AlbumMusik;
        _artisController.text = media.artis;
        _laguController.text = media.jumlahLagu.toString();
      }
    } else {
      _tipeMedia = TipeMedia.Film;
    }
  }

  void _simpanForm() {
    if (_formKey.currentState!.validate()) {
      Media mediaBaru;
      final judul = _judulController.text;
      final tahun = int.parse(_tahunController.text);
      final genre = _genreController.text;

      switch (_tipeMedia) {
        case TipeMedia.Film:
          mediaBaru = Film(judul, tahun, genre, null, _sutradaraController.text,
              int.parse(_durasiController.text), rating: _rating); // DIUBAH
          break;
        case TipeMedia.Buku:
          mediaBaru = Buku(judul, tahun, genre, null, _penulisController.text,
              int.parse(_halamanController.text), catatan: _catatanController.text); // DIUBAH
          break;
        case TipeMedia.AlbumMusik:
          mediaBaru = AlbumMusik(judul, tahun, genre, null,
              _artisController.text, int.parse(_laguController.text));
          break;
      }
      Navigator.pop(context, mediaBaru);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Media' : 'Tambah Media Baru'),
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
              // ... form umum tidak berubah ...
              DropdownButtonFormField<TipeMedia>(
                value: _tipeMedia,
                decoration: const InputDecoration(labelText: 'Tipe Media'),
                items: TipeMedia.values
                    .map((tipe) => DropdownMenuItem(value: tipe, child: Text(tipe.name)))
                    .toList(),
                onChanged: _isEditing ? null : (value) => setState(() => _tipeMedia = value!),
              ),
              TextFormField(controller: _judulController, decoration: const InputDecoration(labelText: 'Judul')),
              TextFormField(controller: _tahunController, decoration: const InputDecoration(labelText: 'Tahun Rilis'), keyboardType: TextInputType.number),
              TextFormField(controller: _genreController, decoration: const InputDecoration(labelText: 'Genre')),
              
              if (_tipeMedia == TipeMedia.Film) ...[
                TextFormField(controller: _sutradaraController, decoration: const InputDecoration(labelText: 'Sutradara')),
                TextFormField(controller: _durasiController, decoration: const InputDecoration(labelText: 'Durasi (menit)'), keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                // BARU: Input Rating Bintang
                Text('Rating: ${_rating.toStringAsFixed(1)} / 5.0'),
                Slider(
                  value: _rating,
                  min: 0.0,
                  max: 5.0,
                  divisions: 10,
                  label: _rating.toStringAsFixed(1),
                  onChanged: (value) => setState(() => _rating = value),
                ),
              ] else if (_tipeMedia == TipeMedia.Buku) ...[
                TextFormField(controller: _penulisController, decoration: const InputDecoration(labelText: 'Penulis')),
                TextFormField(controller: _halamanController, decoration: const InputDecoration(labelText: 'Jumlah Halaman'), keyboardType: TextInputType.number),
                // BARU: Input Catatan Pribadi
                TextFormField(controller: _catatanController, decoration: const InputDecoration(labelText: 'Catatan Pribadi'), maxLines: 3),
              ] else if (_tipeMedia == TipeMedia.AlbumMusik) ...[
                TextFormField(controller: _artisController, decoration: const InputDecoration(labelText: 'Artis')),
                TextFormField(controller: _laguController, decoration: const InputDecoration(labelText: 'Jumlah Lagu'), keyboardType: TextInputType.number),
              ],
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _simpanForm, child: const Text('Simpan'))
            ],
          ),
        ),
      ),
    );
  }
}