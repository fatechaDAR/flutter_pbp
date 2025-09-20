// lib/home_page.dart

import 'package:flutter/material.dart';
import 'models/media.dart';
import 'models/film.dart';
import 'models/buku.dart';
import 'models/album_musik.dart';
import 'detail_page.dart';
import 'add_media_page.dart'; // <-- Import halaman tambah yang baru

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Daftar media sekarang dimulai dari list kosong
  final List<Media> _daftarMedia = [];

  void _bukaHalamanDetail(Media media) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(media: media),
      ),
    );
  }

  // Fungsi untuk membuka halaman tambah dan menerima data baru
  void _bukaHalamanTambahMedia() async {
    // Tunggu hasil dari AddMediaPage
    final mediaBaru = await Navigator.push<Media>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddMediaPage(),
      ),
    );

    // Jika ada data baru yang dikirim kembali, tambahkan ke list
    if (mediaBaru != null) {
      setState(() {
        _daftarMedia.add(mediaBaru);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Koleksi Media'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: _daftarMedia.isEmpty
          ? const Center(
              child: Text('Koleksi Anda masih kosong.\nTekan tombol + untuk menambah.'),
            )
          : ListView.builder(
              itemCount: _daftarMedia.length,
              itemBuilder: (context, index) {
                final media = _daftarMedia[index];

                IconData ikon;
                String subtitle;
                if (media is Film) {
                  ikon = Icons.movie;
                  subtitle = 'Film oleh ${(media as Film).sutradara}';
                } else if (media is Buku) {
                  ikon = Icons.book;
                  subtitle = 'Buku oleh ${(media as Buku).penulis}';
                } else if (media is AlbumMusik) {
                  ikon = Icons.music_note;
                  subtitle = 'Album oleh ${(media as AlbumMusik).artis}';
                } else {
                  ikon = Icons.perm_media;
                  subtitle = 'Media';
                }

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: Icon(ikon, color: Colors.indigo),
                    title: Text(media.judul),
                    subtitle: Text(subtitle),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _bukaHalamanDetail(media),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bukaHalamanTambahMedia, // <-- Panggil fungsi ini
        child: const Icon(Icons.add),
      ),
    );
  }
}