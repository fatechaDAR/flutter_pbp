// lib/detail_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart'; // BARU: Import url_launcher
import 'models/media.dart';
import 'models/film.dart';
import 'models/buku.dart';
import 'models/album_musik.dart';
// import 'webview_page.dart'; // DIHAPUS

class DetailPage extends StatefulWidget {
  final Media media;
  const DetailPage({super.key, required this.media});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late StatusProgress _statusSaatIni;
  bool _adaPerubahan = false;

  @override
  void initState() {
    super.initState();
    _statusSaatIni = widget.media.status;
  }

  // DIUBAH: Fungsi ini sekarang menggunakan url_launcher
  Future<void> _bukaUrlEksternal() async {
    String searchEngine;
    if (widget.media is Film) {
      searchEngine = 'https://www.imdb.com/find?q=';
    } else if (widget.media is Buku) {
      searchEngine = 'https://www.goodreads.com/search?q=';
    } else {
      searchEngine = 'https://www.google.com/search?q=';
    }

    final String urlString = searchEngine + Uri.encodeComponent(widget.media.judul);
    final Uri url = Uri.parse(urlString);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication); // Membuka di tab/aplikasi baru
    } else {
      // Tampilkan pesan error jika tidak bisa membuka URL
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak bisa membuka URL: $urlString')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _adaPerubahan);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.media.judul),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.media.judul,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Rilis: ${widget.media.tahunRilis} | Genre: ${widget.media.genre}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey)),
              const Divider(height: 32),
              
              const Text('Status Progress:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              SegmentedButton<StatusProgress>(
                segments: const [
                  ButtonSegment(
                      value: StatusProgress.Belum,
                      label: Text('Belum'),
                      icon: Icon(Icons.watch_later_outlined)),
                  ButtonSegment(
                      value: StatusProgress.Sedang,
                      label: Text('Sedang'),
                      icon: Icon(Icons.watch_later)),
                  ButtonSegment(
                      value: StatusProgress.Selesai,
                      label: Text('Selesai'),
                      icon: Icon(Icons.check_circle)),
                ],
                selected: {_statusSaatIni},
                onSelectionChanged: (Set<StatusProgress> statusBaru) {
                  setState(() {
                    _statusSaatIni = statusBaru.first;
                    widget.media.status = statusBaru.first;
                    _adaPerubahan = true;
                  });
                },
              ),
              const Divider(height: 32),

              if (widget.media is Film) ...[
                _buildDetailRow('Sutradara:', (widget.media as Film).sutradara),
                _buildDetailRow('Durasi:', '${(widget.media as Film).durasiMenit} menit'),
                _buildRatingStars((widget.media as Film).ratingBintang),
              ] else if (widget.media is Buku) ...[
                _buildDetailRow('Penulis:', (widget.media as Buku).penulis),
                _buildDetailRow('Halaman:', '${(widget.media as Buku).jumlahHalaman} halaman'),
                if ((widget.media as Buku).catatanPribadi.isNotEmpty)
                  _buildCatatan((widget.media as Buku).catatanPribadi),
              ] else if (widget.media is AlbumMusik) ...[
                _buildDetailRow('Artis:', (widget.media as AlbumMusik).artis),
                _buildDetailRow('Jumlah Lagu:', '${(widget.media as AlbumMusik).jumlahLagu} lagu'),
              ],

              const SizedBox(height: 24),

              // Tombol sekarang memanggil _bukaUrlEksternal
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.public),
                  label: const Text('Lihat Info Online'),
                  onPressed: _bukaUrlEksternal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
            width: 120,
            child: Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16))),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
      ]),
    );
  }

  Widget _buildRatingStars(double rating) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      Icon icon;
      if (i < rating.floor()) {
        icon = const Icon(Icons.star, color: Colors.amber);
      } else if (i < rating) {
        icon = const Icon(Icons.star_half, color: Colors.amber);
      } else {
        icon = const Icon(Icons.star_border, color: Colors.amber);
      }
      stars.add(icon);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(children: [
        const SizedBox(
            width: 120,
            child: Text('Rating:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
        ...stars
      ]),
    );
  }
  
  Widget _buildCatatan(String catatan) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Catatan Pribadi:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text(catatan,
            style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
      ]),
    );
  }
}