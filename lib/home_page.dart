// lib/home_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart'; 
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
  String? _genreFilter;
  UrutkanBerdasarkan _urutanAktif = UrutkanBerdasarkan.Judul;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    _loadMedia();
    _initDeviceInfo();
    // DIUBAH: Listener untuk search bar sekarang ada di sini
    _searchController.addListener(() {
      setState(() {
        // Cukup panggil setState agar getter mediaYangDitampilkan dieksekusi ulang
      });
    });
  }

  // DIUBAH: webBrowserInfo() menjadi webBrowserInfo.data
  Future<void> _initDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> data = {};
    
    try {
      if (kIsWeb) {
        // PERBAIKAN: webBrowserInfo adalah getter, bukan method
        // dan kita butuh .data untuk mendapatkan Map-nya
        data = (await deviceInfoPlugin.webBrowserInfo).data;
      } else {
        // data = (await deviceInfoPlugin.androidInfo).data;
      }
    } catch (e) {
      data = {'Error': 'Gagal mendapatkan info perangkat'};
    }

    if (mounted) {
      setState(() {
        _deviceData = data;
      });
    }
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

  // PERBAIKAN: Logika kembali ke versi Anda yang benar
  void _bukaHalamanDetail(Media media) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(media: media)),
    );
    // DetailPage mengembalikan bool 'true' jika ada perubahan
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

  // PERBAIKAN: Logika kembali ke versi Anda yang benar (menggunakan index)
  void _bukaHalamanEditMedia(int index) async {
    // Cari index asli di _daftarMedia berdasarkan objek dari mediaYangDitampilkan
    final int indexAsli = _daftarMedia.indexOf(mediaYangDitampilkan[index]);
    
    // Jika tidak ditemukan (seharusnya tidak terjadi), jangan lakukan apa-apa
    if (indexAsli == -1) return;

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

  // PERBAIKAN: Logika kembali ke versi Anda yang benar (menggunakan objek)
  void _hapusMedia(Media media) {
    setState(() {
      _daftarMedia.remove(media);
    });
    _saveMedia();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${media.judul} dihapus')));
  }
  
  // PERBAIKAN: Fungsi ini ditambahkan kembali
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
    
    if (_genreFilter != null) {
      hasil = hasil.where((m) => m.genres.contains(_genreFilter)).toList();
    }
    
    // Filter pencarian
    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      hasil = hasil.where((m) => m.judul.toLowerCase().contains(query)).toList();
    }
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Text('Info Perangkat', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ..._deviceData.entries.map((entry) {
              return ListTile(
                title: Text(entry.key),
                subtitle: Text(entry.value.toString(), maxLines: 2, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
          ],
        ),
      ),
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Cari judul...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70), // Pastikan hint terlihat
                ),
                style: TextStyle(color: Colors.white), // Pastikan teks terlihat
                onChanged: (value) { // Panggil setState di onChanged
                  setState(() {});
                },
              )
            : const Text('Koleksi Media'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear(); // Hapus teks saat menutup search bar
                }
              });
            },
          ),
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
          PopupMenuButton<String?>(
            icon: const Icon(Icons.category),
            onSelected: (String? genre) => setState(() => _genreFilter = genre),
            itemBuilder: (BuildContext context) {
              final genres = <String>{};
              for (var m in _daftarMedia) {
                genres.addAll(m.genres);
              }
              final items = <PopupMenuEntry<String?>>[];
              items.add(const PopupMenuItem(child: Text('Semua Genre'), value: null));
              items.addAll(genres.map((g) => PopupMenuItem(child: Text(g), value: g)).toList());
              return items;
            },
          ),
        ],
      ),
      body: mediaYangDitampilkan.isEmpty
          ? const Center(child: Text('Tidak ada media yang ditemukan.')) // Pesan lebih baik
          : ListView.builder(
              itemCount: mediaYangDitampilkan.length,
              itemBuilder: (context, index) {
                final media = mediaYangDitampilkan[index];
                IconData ikon;
                String subtitle;
                
                // --- IMPLEMENTASI POSTER FILM DIMULAI DI SINI ---
                Widget leadingWidget;

                if (media is Film) { 
                  ikon = Icons.movie; 
                  subtitle = 'Film oleh ${(media as Film).sutradara}'; 
                  
                  // Cek jika film punya URL gambar
                  if (media.urlGambar != null && media.urlGambar!.isNotEmpty) {
                    leadingWidget = CircleAvatar(
                      backgroundImage: NetworkImage(media.urlGambar!),
                      radius: 28, // Beri ukuran
                      onBackgroundImageError: (exception, stackTrace) {}, // Handle error
                    );
                  } else {
                    // Tampilkan ikon default jika tidak ada URL
                    leadingWidget = CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.indigo.shade100,
                      child: Icon(ikon, color: Colors.indigo),
                    );
                  }

                } else if (media is Buku) { 
                  ikon = Icons.book; 
                  subtitle = 'Buku oleh ${(media as Buku).penulis}'; 
                  leadingWidget = CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.indigo.shade100,
                    child: Icon(ikon, color: Colors.indigo),
                  );
                } else { // AlbumMusik
                  ikon = Icons.music_note; 
                  subtitle = 'Album oleh ${(media as AlbumMusik).artis}'; 
                  leadingWidget = CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.indigo.shade100,
                    child: Icon(ikon, color: Colors.indigo),
                  );
                }
                // --- IMPLEMENTASI POSTER FILM BERAKHIR DI SINI ---


                return Dismissible(
                  key: Key(media.judul + media.tahunRilis.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.symmetric(horizontal: 20), child: const Icon(Icons.delete, color: Colors.white)),
                  onDismissed: (direction) => _hapusMedia(media),
                  child: Card(
                    color: media.isFavorit ? Colors.amber.shade100 : null,
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min, 
                        children: [
                          _buildStatusIndicator(media.status), 
                          const SizedBox(width: 12), 
                          leadingWidget // DIUBAH: Gunakan widget yang sudah disiapkan
                        ]
                      ),
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
                            onPressed: () => _toggleFavoritStatus(media), // PERBAIKAN: Fungsi ini sudah ada
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.grey),
                            onPressed: () => _bukaHalamanEditMedia(index), // PERBAIKAN: Menggunakan index
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