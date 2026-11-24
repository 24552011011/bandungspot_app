import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class UserAccount {
  final String name;
  final String email;
  final String password;

  UserAccount({
    required this.name,
    required this.email,
    required this.password,
  });
}

// Penyimpanan sementara untuk demo Login & Register
class AuthStorage {
  static final List<UserAccount> users = [
    UserAccount(
      name: 'Mochammad Daffa Khairi Dhiaulhaq',
      email: 'daffa@utb-univ.ac.id',
      password: '123456',
    ),
  ];

  static UserAccount? currentUser;

  static bool login(String email, String password) {
    for (var user in users) {
      if (user.email.toLowerCase() == email.toLowerCase() &&
          user.password == password) {
        currentUser = user;
        return true;
      }
    }
    return false;
  }

  static bool register(String name, String email, String password) {
    final exists = users.any(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
    );
    if (exists) return false;

    users.add(UserAccount(name: name, email: email, password: password));
    return true;
  }

  static void logout() {
    currentUser = null;
  }
}

class SpotLocation {
  final String id;
  final String name;
  final String category;
  final String address;
  final String description;
  final double rating;
  final LatLng coordinates;
  final IconData icon;
  final Color color;
  final String imagePath;

  const SpotLocation({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.description,
    required this.rating,
    required this.coordinates,
    required this.icon,
    required this.color,
    required this.imagePath,
  });
}

const List<SpotLocation> bandungLocations = [
  SpotLocation(
    id: '1',
    name: 'Universitas Teknologi Bandung',
    category: 'Kampus',
    address: 'Jl. Soekarno Hatta No.378, Bandung',
    description:
        'Kampus pusat Universitas Teknologi Bandung (UTB) dengan program studi Teknik Informatika dan teknologi rekayasa.',
    rating: 4.8,
    coordinates: LatLng(-6.9476, 107.6012),
    icon: Icons.school,
    color: Color(0xFF1E3A8A),
    imagePath: 'assets/images/kampus_utb.jpeg',
  ),
  SpotLocation(
    id: '2',
    name: 'Gedung Sate',
    category: 'Sejarah',
    address: 'Jl. Diponegoro No.22, Citarum, Bandung',
    description:
        'Ikon arsitektur bersejarah Kota Bandung yang berfungsi sebagai kantor Gubernur Jawa Barat dengan ornamen tusuk sate di puncaknya.',
    rating: 4.9,
    coordinates: LatLng(-6.9025, 107.6188),
    icon: Icons.account_balance,
    color: Color(0xFFB45309),
    imagePath: 'assets/images/gedung_sate.jpg',
  ),
  SpotLocation(
    id: '3',
    name: 'Jalan Braga',
    category: 'Wisata Kota',
    address: 'Jl. Braga, Sumur Bandung, Bandung',
    description:
        'Kawasan klasik bergaya kolonial yang dipenuhi kafe estetik, galeri seni jalanan, dan bangunan bersejarah.',
    rating: 4.7,
    coordinates: LatLng(-6.9178, 107.6094),
    icon: Icons.storefront,
    color: Color(0xFF7C3AED),
    imagePath: 'assets/images/braga.jpg',
  ),
  SpotLocation(
    id: '4',
    name: 'Alun-Alun Bandung',
    category: 'Ruang Publik',
    address: 'Jl. Asia Afrika, Balonggede, Bandung',
    description:
        'Taman pusat kota dengan hamparan rumput sintetis luas yang bersebelahan langsung dengan Masjid Raya Bandung.',
    rating: 4.6,
    coordinates: LatLng(-6.9218, 107.6071),
    icon: Icons.park,
    color: Color(0xFF047857),
    imagePath: 'assets/images/alun_alun.jpg',
  ),
  SpotLocation(
    id: '5',
    name: 'Museum Geologi',
    category: 'Edukasi',
    address: 'Jl. Diponegoro No.57, Cihaur Geulis, Bandung',
    description:
        'Museum edukatif yang menyimpan koleksi fosil purbakala, batuan mineral, serta sejarah geologi nusantara.',
    rating: 4.8,
    coordinates: LatLng(-6.9007, 107.6214),
    icon: Icons.museum,
    color: Color(0xFF0369A1),
    imagePath: 'assets/images/museum_geologi.jpg',
  ),
  SpotLocation(
    id: '6',
    name: 'Trans Studio Bandung',
    category: 'Hiburan',
    address: 'Jl. Gatot Subroto No.289, Cibangkong, Bandung',
    description:
        'Taman hiburan indoor berskala besar dengan berbagai wahana permainan keluarga dan pertunjukan tematik.',
    rating: 4.7,
    coordinates: LatLng(-6.9259, 107.6365),
    icon: Icons.attractions,
    color: Color(0xFFBE123C),
    imagePath: 'assets/images/trans_studio.jpg',
  ),
];