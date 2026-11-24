import 'package:flutter/material.dart';
import '../models/app_data.dart';
import 'about_screen.dart';
import 'info_grid_screen.dart';
import 'login_screen.dart';
import 'map_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  SpotLocation? _focusedLocation;

  final List<String> _titles = [
    'Peta Bandung',
    'List Informasi Lokasi',
    'Tentang Aplikasi',
  ];

  void _openLocationOnMap(SpotLocation location) {
    setState(() {
      _focusedLocation = location;
      _selectedIndex = 0;
    });
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              AuthStorage.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthStorage.currentUser;

    final List<Widget> pages = [
      MapScreen(initialFocusLocation: _focusedLocation),
      InfoGridScreen(onViewOnMap: _openLocationOnMap),
      const AboutScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Color(0xFF1E3A8A),
                ),
              ),
              accountName: Text(
                user?.name ?? 'Pengguna BandungSpot',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(user?.email ?? 'guest@utb-univ.ac.id'),
            ),
            ListTile(
              leading: const Icon(Icons.map_outlined),
              title: const Text('Peta Lokasi'),
              selected: _selectedIndex == 0,
              selectedColor: const Color(0xFF1E3A8A),
              onTap: () {
                setState(() => _selectedIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_view_rounded),
              title: const Text('List Informasi'),
              selected: _selectedIndex == 1,
              selectedColor: const Color(0xFF1E3A8A),
              onTap: () {
                setState(() => _selectedIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Tentang Aplikasi'),
              selected: _selectedIndex == 2,
              selectedColor: const Color(0xFF1E3A8A),
              onTap: () {
                setState(() => _selectedIndex = 2);
                Navigator.pop(context);
              },
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () {
                Navigator.pop(context);
                _confirmLogout();
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
      body: pages[_selectedIndex],
    );
  }
}