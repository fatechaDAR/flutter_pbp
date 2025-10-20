// lib/add_media_page.dart

import 'package:flutter/material.dart';
import 'models/media.dart';
import 'models/film.dart';
import 'models/buku.dart';
import 'models/album_musik.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // Controller umum
  final _judulController = TextEditingController();
  final _tahunController = TextEditingController();
  // genres: available and selected
  List<String> _availableGenres = [
    'Action',
    'Drama',
    'Sci-Fi',
    'Fantasy',
    'Horror',
    'Romance',
    'Comedy'
  ];
  final List<String> _selectedGenres = [];
  final _urlGambarController = TextEditingController(); 

  
  final _sutradaraController = TextEditingController();
  final _durasiController = TextEditingController();
  double _rating = 0.0; 

  // Controller spesifik Buku
  final _penulisController = TextEditingController();
  final _catatanController = TextEditingController();
  final _halamanDibacaController = TextEditingController(); 

  // Controller spesifik Album Musik
  final _artisController = TextEditingController();
  final _laguController = TextEditingController();


  StatusProgress _statusSaatIni = StatusProgress.Belum; 
  bool _isFavorit = false; 


  @override
  void initState() {
    super.initState();
    _loadAvailableGenres();
    if (_isEditing) {
      final media = widget.mediaToEdit!;
      _judulController.text = media.judul;
      _tahunController.text = media.tahunRilis.toString();
      // ensure genres from media are in available list and selected
      for (var g in media.genres) {
        if (!_availableGenres.contains(g)) _availableGenres.add(g);
        if (!_selectedGenres.contains(g)) _selectedGenres.add(g);
      }
      _urlGambarController.text = media.urlGambar ?? ''; 
      _statusSaatIni = media.status; 
      _isFavorit = media.isFavorit; 

      if (media is Film) {
        _tipeMedia = TipeMedia.Film;
        _sutradaraController.text = media.sutradara;
        _durasiController.text = media.durasiMenit.toString();
        _rating = media.ratingBintang;
        } else if (media is Buku) {
        _tipeMedia = TipeMedia.Buku;
        _penulisController.text = media.penulis;
        _catatanController.text = media.catatanPribadi;
        _halamanDibacaController.text = media.halamanDibaca.toString(); // BARU: Load halaman dibaca
      } else if (media is AlbumMusik) {
        _tipeMedia = TipeMedia.AlbumMusik;
        _artisController.text = media.artis;
        _laguController.text = media.jumlahLagu.toString();
      }
    } else {
      _tipeMedia = TipeMedia.Film;
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _tahunController.dispose();
    _urlGambarController.dispose();
    _sutradaraController.dispose();
    _durasiController.dispose();
    _penulisController.dispose();
    _catatanController.dispose();
    _halamanDibacaController.dispose(); // BARU: Dispose
    _artisController.dispose();
    _laguController.dispose();
    super.dispose();
  }

  Future<void> _loadAvailableGenres() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? saved = prefs.getStringList('available_genres');
      if (saved != null && saved.isNotEmpty) {
        setState(() {
          _availableGenres = saved;
        });
      }
    } catch (_) {}
  }

  Future<void> _saveAvailableGenres() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('available_genres', _availableGenres);
    } catch (_) {}
  }

  void _simpanForm() {
    if (_formKey.currentState!.validate()) {
      Media mediaBaru;
      final judul = _judulController.text;
      final tahun = int.parse(_tahunController.text);
      final List<String> genreList = List.from(_selectedGenres);
      final urlGambar = _urlGambarController.text.isEmpty ? null : _urlGambarController.text; // Ambil URL gambar

      switch (_tipeMedia) {
        case TipeMedia.Film:
          mediaBaru = Film(
            judul, tahun, genreList, urlGambar,
            _sutradaraController.text,
            int.parse(_durasiController.text),
            rating: _rating,
            status: _statusSaatIni, 
            isFavorit: _isFavorit, 
          );
          break;
        case TipeMedia.Buku:
          mediaBaru = Buku(
            judul, tahun, genreList, urlGambar,
            _penulisController.text,
            catatan: _catatanController.text,
            status: _statusSaatIni,
            isFavorit: _isFavorit,
            halamanDibaca: int.tryParse(_halamanDibacaController.text) ?? 0,
          );
          break;
        case TipeMedia.AlbumMusik:
          mediaBaru = AlbumMusik(
            judul, tahun, genreList, urlGambar,
            _artisController.text,
            int.parse(_laguController.text),
            status: _statusSaatIni, // Tambahkan status
            isFavorit: _isFavorit, // Tambahkan favorit
          );
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
              // Dropdown Tipe Media
              DropdownButtonFormField<TipeMedia>(
                value: _tipeMedia,
                decoration: const InputDecoration(labelText: 'Tipe Media'),
                items: TipeMedia.values
                    .map((tipe) => DropdownMenuItem(value: tipe, child: Text(tipe.name)))
                    .toList(),
                onChanged: _isEditing ? null : (value) => setState(() => _tipeMedia = value!),
              ),
              const SizedBox(height: 16),

              // Field Umum
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (value) => value!.isEmpty ? 'Judul tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _tahunController,
                decoration: const InputDecoration(labelText: 'Tahun Rilis'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Tahun rilis tidak boleh kosong';
                  if (int.tryParse(value) == null) return 'Masukkan angka yang valid';
                  return null;
                },
              ),
              // Genre selection using FilterChips
              const SizedBox(height: 8),
              const Text('Genre:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ..._availableGenres.map((g) {
                    final bool selected = _selectedGenres.contains(g);
                    return FilterChip(
                      label: Text(g),
                      selected: selected,
                      onSelected: (v) {
                        setState(() {
                          if (v) _selectedGenres.add(g);
                          else _selectedGenres.remove(g);
                        });
                      },
                    );
                  }).toList(),
                  // Add new genre chip
                  ActionChip(
                    label: const Text('Tambahkan Genre Baru'),
                    avatar: const Icon(Icons.add),
                    onPressed: () async {
                      final String? newGenre = await showDialog<String>(
                        context: context,
                        builder: (context) {
                          final _newGenreController = TextEditingController();
                          return AlertDialog(
                            title: const Text('Tambah Genre Baru'),
                            content: TextFormField(
                              controller: _newGenreController,
                              decoration: const InputDecoration(labelText: 'Nama Genre'),
                            ),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                              TextButton(
                                onPressed: () {
                                  final text = _newGenreController.text.trim();
                                  if (text.isNotEmpty) Navigator.pop(context, text);
                                },
                                child: const Text('Tambah'),
                              ),
                            ],
                          );
                        },
                      );
                      if (newGenre != null) {
                        setState(() {
                          if (!_availableGenres.contains(newGenre)) {
                            _availableGenres.add(newGenre);
                            _saveAvailableGenres();
                          }
                          if (!_selectedGenres.contains(newGenre)) _selectedGenres.add(newGenre);
                        });
                      }
                    },
                  ),
                ],
              ),
              TextFormField( // Asumsi ada field URL gambar
                controller: _urlGambarController,
                decoration: const InputDecoration(labelText: 'URL Gambar (opsional)'),
              ),
              const SizedBox(height: 16),

              // Input Status Progress
              const Text('Status Progress:', style: TextStyle(fontWeight: FontWeight.bold)),
              SegmentedButton<StatusProgress>(
                segments: const [
                  ButtonSegment(value: StatusProgress.Belum, label: Text('Belum')),
                  ButtonSegment(value: StatusProgress.Sedang, label: Text('Sedang')),
                  ButtonSegment(value: StatusProgress.Selesai, label: Text('Selesai')),
                ],
                selected: {_statusSaatIni},
                onSelectionChanged: (Set<StatusProgress> statusBaru) {
                  setState(() {
                    _statusSaatIni = statusBaru.first;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Checkbox Favorit
              Row(
                children: [
                  Checkbox(
                    value: _isFavorit,
                    onChanged: (bool? value) {
                      setState(() {
                        _isFavorit = value!;
                      });
                    },
                  ),
                  const Text('Tandai sebagai Favorit'),
                ],
              ),
              const SizedBox(height: 16),


              // Field Spesifik Tipe Media
              if (_tipeMedia == TipeMedia.Film) ...[
                TextFormField(
                  controller: _sutradaraController,
                  decoration: const InputDecoration(labelText: 'Sutradara'),
                  validator: (value) => value!.isEmpty ? 'Sutradara tidak boleh kosong' : null,
                ),
                TextFormField(
                  controller: _durasiController,
                  decoration: const InputDecoration(labelText: 'Durasi (menit)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Durasi tidak boleh kosong';
                    if (int.tryParse(value) == null) return 'Masukkan angka yang valid';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
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
                TextFormField(
                  controller: _penulisController,
                  decoration: const InputDecoration(labelText: 'Penulis'),
                  validator: (value) => value!.isEmpty ? 'Penulis tidak boleh kosong' : null,
                ),
                // Hapus input jumlah halaman total. Kita hanya menyimpan "halaman yang sudah dibaca".
                // Tampilkan field halamanDibaca ketika status bukan Selesai.
                if (_statusSaatIni != StatusProgress.Selesai)
                  TextFormField(
                    controller: _halamanDibacaController,
                    decoration: const InputDecoration(labelText: 'Halaman yang Sudah Dibaca (opsional)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return null; // Opsional
                      final int? dibaca = int.tryParse(value);
                      if (dibaca == null || dibaca < 0) return 'Masukkan angka positif yang valid';
                      return null;
                    },
                  ),
                TextFormField(
                  controller: _catatanController,
                  decoration: const InputDecoration(labelText: 'Catatan Pribadi'),
                  maxLines: 3,
                ),
              ] else if (_tipeMedia == TipeMedia.AlbumMusik) ...[
                TextFormField(
                  controller: _artisController,
                  decoration: const InputDecoration(labelText: 'Artis'),
                  validator: (value) => value!.isEmpty ? 'Artis tidak boleh kosong' : null,
                ),
                TextFormField(
                  controller: _laguController,
                  decoration: const InputDecoration(labelText: 'Jumlah Lagu'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Jumlah lagu tidak boleh kosong';
                    if (int.tryParse(value) == null) return 'Masukkan angka yang valid';
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _simpanForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: Text(_isEditing ? 'Simpan Perubahan' : 'Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}