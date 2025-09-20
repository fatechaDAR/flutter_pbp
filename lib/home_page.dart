// lib/home_page.dart

import 'package:flutter/material.dart';
import 'models/media.dart';
import 'models/film.dart';
import 'models/buku.dart';
import 'models/album_musik.dart';
import 'detail_page.dart'; // Import halaman detail yang baru

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Data dummy untuk ditampilkan di list
  // List ini bisa menampung berbagai jenis Media (Polymorphism)
  final List<Media> _daftarMedia = [
    Film('Inception', 2010, 'Sci-Fi', 'assets/pudidi.png', 'Christopher Nolan', 148),
    Buku('Laskar Pelangi', 2005, 'Novel', null, 'Andrea Hirata', 529),
    AlbumMusik('A Head Full of Dreams', 2015, 'Pop Rock', null, 'Coldplay', 12),
    Film('The Dark Knight', 2008, 'Action', 'assets/pudidi.png', 'Christopher Nolan', 152),
    Buku('Bumi Manusia', 1980, 'Sejarah', null, 'Pramoedya Ananta Toer', 535),
  ];

  // Fungsi untuk navigasi ke halaman detail
  void _bukaHalamanDetail(Media media) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(media: media),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Koleksi Media'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: _daftarMedia.length,
        itemBuilder: (context, index) {
          final media = _daftarMedia[index];

          // Siapkan ikon dan subtitle berdasarkan tipe media
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
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
        onPressed: () {
          // TODO: Buat fungsi untuk menambah media baru
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}