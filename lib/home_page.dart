// lib/home_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'models/media.dart';
import 'models/film.dart';
import 'models/buku.dart';
import 'models/album_musik.dart';
import 'detail_page.dart';
import 'add_media_page.dart';

enum TipeMediaFilter { Film, Buku, AlbumMusik }
enum UrutkanBerdasarkan { Judul, Tahun }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Media> _daftarMedia = [];
  
  TipeMediaFilter? _filterAktif;
  UrutkanBerdasarkan _urutanAktif = UrutkanBerdasarkan.Judul;

  @override
  void initState() {
    super.initState();
    _loadMedia();
  }

  Future<void> _loadMedia() async {
    final prefs = await SharedPreferences.getInstance();
    final String? mediaString = prefs.getString('daftar_media');
    if (mediaString != null) {
      final List<dynamic> mediaJson = jsonDecode(mediaString);
      setState(() {
        _daftarMedia.clear();
        _daftarMedia.addAll(mediaJson.map((json) => Media.fromJson(json)));
      });
    }
  }

  Future<void> _saveMedia() async {
    final prefs = await SharedPreferences.getInstance();
    final String mediaString =
        jsonEncode(_daftarMedia.map((media) => media.toJson()).toList());
    await prefs.setString('daftar_media', mediaString);
  }

  void _bukaHalamanDetail(Media media) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(media: media)),
    );
    if (result == true) {
      setState(() {});
      _saveMedia();
    }
  }

  void _bukaHalamanTambahMedia() async {
    final mediaBaru = await Navigator.push<Media>(
        context, MaterialPageRoute(builder: (context) => const AddMediaPage()));
    if (mediaBaru != null) {
      setState(() {
        _daftarMedia.add(mediaBaru);
      });
      _saveMedia();
    }
  }

  void _bukaHalamanEditMedia(int index) async {
    final int indexAsli = _daftarMedia.indexOf(mediaYangDitampilkan[index]);
    final mediaDiedit = await Navigator.push<Media>(
      context,
      MaterialPageRoute(builder: (context) => AddMediaPage(mediaToEdit: _daftarMedia[indexAsli])),
    );
    if (mediaDiedit != null) {
      setState(() {
        _daftarMedia[indexAsli] = mediaDiedit;
      });
      _saveMedia();
    }
  }

  void _hapusMedia(Media media) {
    setState(() {
      _daftarMedia.remove(media);
    });
    _saveMedia();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${media.judul} dihapus')));
  }

  
  void _toggleFavoritStatus(Media media) {
    setState(() {
      media.toggleFavorit();
    });
    _saveMedia(); 
  }

  List<Media> get mediaYangDitampilkan {
    List<Media> hasil;
    if (_filterAktif != null) {
      hasil = _daftarMedia.where((media) {
        if (_filterAktif == TipeMediaFilter.Film) return media is Film;
        if (_filterAktif == TipeMediaFilter.Buku) return media is Buku;
        if (_filterAktif == TipeMediaFilter.AlbumMusik) return media is AlbumMusik;
        return false;
      }).toList();
    } else {
      hasil = List.from(_daftarMedia);
    }
    hasil.sort((a, b) {
      switch (_urutanAktif) {
        case UrutkanBerdasarkan.Tahun:
          return a.tahunRilis.compareTo(b.tahunRilis);
        case UrutkanBerdasarkan.Judul:
        default:
          return a.judul.toLowerCase().compareTo(b.judul.toLowerCase());
      }
    });
    return hasil;
  }

  Widget _buildStatusIndicator(StatusProgress status) {
    Color color;
    switch (status) {
      case StatusProgress.Selesai: color = Colors.green; break;
      case StatusProgress.Sedang: color = Colors.orange; break;
      default: color = Colors.grey; break;
    }
    return Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Koleksi Media'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<TipeMediaFilter?>(
            icon: const Icon(Icons.filter_list),
            onSelected: (TipeMediaFilter? tipe) => setState(() => _filterAktif = tipe),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(child: Text('Tampilkan Semua'), value: null),
              const PopupMenuItem(child: Text('Hanya Film'), value: TipeMediaFilter.Film),
              const PopupMenuItem(child: Text('Hanya Buku'), value: TipeMediaFilter.Buku),
              const PopupMenuItem(child: Text('Hanya Album'), value: TipeMediaFilter.AlbumMusik),
            ],
          ),
          PopupMenuButton<UrutkanBerdasarkan>(
            icon: const Icon(Icons.sort),
            onSelected: (UrutkanBerdasarkan urutan) => setState(() => _urutanAktif = urutan),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(child: Text('Urutkan Judul'), value: UrutkanBerdasarkan.Judul),
              const PopupMenuItem(child: Text('Urutkan Tahun'), value: UrutkanBerdasarkan.Tahun),
            ],
          ),
        ],
      ),
      body: mediaYangDitampilkan.isEmpty
          ? const Center(child: Text('Tidak ada media. Tekan + untuk menambah.'))
          : ListView.builder(
              itemCount: mediaYangDitampilkan.length,
              itemBuilder: (context, index) {
                final media = mediaYangDitampilkan[index];
                IconData ikon;
                String subtitle;
                if (media is Film) { ikon = Icons.movie; subtitle = 'Film oleh ${(media as Film).sutradara}'; } 
                else if (media is Buku) { ikon = Icons.book; subtitle = 'Buku oleh ${(media as Buku).penulis}'; } 
                else { ikon = Icons.music_note; subtitle = 'Album oleh ${(media as AlbumMusik).artis}'; }

                return Dismissible(
                  key: Key(media.judul + media.tahunRilis.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(color: const Color.fromARGB(255, 231, 35, 21), alignment: Alignment.centerRight, padding: const EdgeInsets.symmetric(horizontal: 20), child: const Icon(Icons.delete, color: Colors.white)),
                  onDismissed: (direction) => _hapusMedia(media),
                  child: Card(
                    // DIUBAH: Tambahkan warna latar belakang jika favorit
                    color: media.isFavorit ? const Color.fromARGB(255, 134, 192, 202) : null,
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      leading: Row(mainAxisSize: MainAxisSize.min, children: [_buildStatusIndicator(media.status), const SizedBox(width: 12), Icon(ikon, color: Colors.indigo)]),
                      title: Text(media.judul),
                      subtitle: Text(subtitle),
                      
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              media.isFavorit ? Icons.favorite : Icons.favorite_border,
                              color: Colors.redAccent,
                            ),
                            onPressed: () => _toggleFavoritStatus(media),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.grey),
                            onPressed: () => _bukaHalamanEditMedia(index),
                          ),
                        ],
                      ),
                      onTap: () => _bukaHalamanDetail(media),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bukaHalamanTambahMedia,
        tooltip: 'Tambah Media',
        child: const Icon(Icons.add),
      ),
    );
  }
}