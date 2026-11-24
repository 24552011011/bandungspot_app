import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          CircleAvatar(
            radius: 48,
            backgroundColor: const Color(0xFF1E3A8A),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Image.asset(
                'assets/images/pin_maps.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'BandungSpot',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Versi 1.0.0',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tentang Aplikasi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'BandungSpot adalah aplikasi pemetaan dan informasi lokasi populer di Kota Bandung yang dibangun menggunakan Flutter serta integrasi library flutter_map (OpenStreetMap). Aplikasi ini disusun untuk memenuhi Ujian Tengah Semester (UTS) Mata Kuliah Pemrograman Mobile 2.',
                    textAlign: TextAlign.justify,
                  ),
                  Divider(height: 24),
                  Text(
                    'Informasi Mata Kuliah',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text('Mata Kuliah : Pemrograman Mobile 2 (3 SKS)'),
                  Text('Dosen : Nova Agustina, S.T., M.Kom.'),
                  Text('Kelas : TIF RM 24 A'),
                  Text('Institusi : Universitas Teknologi Bandung'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF1E3A8A).withValues(alpha: 0.3),
              ),
            ),
            child: const Text(
              'Copyright © 2026 by MochammadDaffaKhairiDhiaulhaq_24552011011',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}