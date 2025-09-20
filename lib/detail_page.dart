// lib/detail_page.dart

import 'package:flutter/material.dart';
import 'models/media.dart';
import 'models/film.dart';
import 'models/buku.dart';
import 'models/album_musik.dart';

class DetailPage extends StatelessWidget {
  final Media media;

  const DetailPage({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(media.judul),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  // Gunakan gambar default jika URL null atau kosong
                  media.urlGambar ?? 'assets/pudidi.png',
                  height: 250,
                  fit: BoxFit.cover,
                  // Error builder untuk handle jika gambar dari URL gagal dimuat
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/pudidi.png', height: 250, fit: BoxFit.cover);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              media.judul,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Rilis: ${media.tahunRilis} | Genre: ${media.genre}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Divider(height: 32),
            
            // Tampilkan detail spesifik berdasarkan tipe media
            // Ini adalah contoh nyata Polymorphism di UI
            if (media is Film) ...[
              _buildDetailRow('Sutradara:', (media as Film).sutradara),
              _buildDetailRow('Durasi:', '${(media as Film).durasiMenit} menit'),
            ] else if (media is Buku) ...[
              _buildDetailRow('Penulis:', (media as Buku).penulis),
              _buildDetailRow('Halaman:', '${(media as Buku).jumlahHalaman} halaman'),
            ] else if (media is AlbumMusik) ...[
              _buildDetailRow('Artis:', (media as AlbumMusik).artis),
              _buildDetailRow('Jumlah Lagu:', '${(media as AlbumMusik).jumlahLagu} lagu'),
            ],
          ],
        ),
      ),
    );
  }

  // Widget bantuan untuk membuat baris detail agar rapi
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}