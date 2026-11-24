import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/app_data.dart';

class MapScreen extends StatefulWidget {
  final SpotLocation? initialFocusLocation;

  const MapScreen({super.key, this.initialFocusLocation});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  final LatLng _bandungCenter = const LatLng(-6.9175, 107.6191);
  SpotLocation? _selectedSpot;
  String _searchQuery = '';
  List<SpotLocation> _filteredSpots = [];

  @override
  void initState() {
    super.initState();
    _selectedSpot = widget.initialFocusLocation;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      if (query.trim().isEmpty) {
        _filteredSpots = [];
      } else {
        final lowerQuery = query.toLowerCase();
        _filteredSpots = bandungLocations.where((spot) {
          return spot.name.toLowerCase().contains(lowerQuery) ||
              spot.category.toLowerCase().contains(lowerQuery) ||
              spot.address.toLowerCase().contains(lowerQuery);
        }).toList();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    setState(() {
      _searchQuery = '';
      _filteredSpots = [];
    });
  }

  void _focusToSpot(SpotLocation spot) {
    _searchFocusNode.unfocus();
    setState(() {
      _selectedSpot = spot;
      _searchController.text = spot.name;
      _searchQuery = '';
      _filteredSpots = [];
    });
    _mapController.move(spot.coordinates, 15.5);
    _showSpotBottomSheet(spot);
  }

  void _zoomIn() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, currentZoom + 1);
  }

  void _zoomOut() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, currentZoom - 1);
  }

  void _resetCenter() {
    _clearSearch();
    setState(() => _selectedSpot = null);
    _mapController.move(_bandungCenter, 12.5);
  }

  void _showSpotBottomSheet(SpotLocation spot) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: spot.color.withValues(alpha: 0.15),
                  child: Icon(spot.icon, color: spot.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spot.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${spot.category} • ⭐ ${spot.rating}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.place_outlined, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    spot.address,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(spot.description),
            const SizedBox(height: 12),
            Text(
              'Koordinat: ${spot.coordinates.latitude.toStringAsFixed(4)}, ${spot.coordinates.longitude.toStringAsFixed(4)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final startCenter =
        widget.initialFocusLocation?.coordinates ?? _bandungCenter;
    final startZoom = widget.initialFocusLocation != null ? 15.5 : 12.5;

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: startCenter,
            initialZoom: startZoom,
            minZoom: 5,
            maxZoom: 18,
            onTap: (_, _) {
              // Tutup saran pencarian & keyboard saat peta diketuk
              _searchFocusNode.unfocus();
              if (_filteredSpots.isNotEmpty || _searchQuery.isNotEmpty) {
                setState(() {
                  _searchQuery = '';
                  _filteredSpots = [];
                });
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.utb.bandungspot',
            ),
            MarkerLayer(
              markers: bandungLocations.map((spot) {
                final isSelected = _selectedSpot?.id == spot.id;
                return Marker(
                  point: spot.coordinates,
                  width: isSelected ? 54 : 44,
                  height: isSelected ? 54 : 44,
                  child: GestureDetector(
                    onTap: () => _focusToSpot(spot),
                    child: Tooltip(
                      message: spot.name,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? spot.color : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: spot.color, width: 3),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          spot.icon,
                          color: isSelected ? Colors.white : spot.color,
                          size: isSelected ? 26 : 20,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),

        // Kolom Search + Saran Hasil + Pintasan Lokasi di Bagian Atas
        Positioned(
          top: 12,
          left: 12,
          right: 12,
          child: Column(
            children: [
              // Kotak Pencarian
              Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onChanged: _onSearchChanged,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) {
                    if (_filteredSpots.isNotEmpty) {
                      _focusToSpot(_filteredSpots.first);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari lokasi, kategori, atau jalan...',
                    hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF1E3A8A),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close, color: Colors.grey),
                            onPressed: _clearSearch,
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),

              // Dropdown Daftar Hasil Pencarian
              if (_searchQuery.trim().isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  constraints: const BoxConstraints(maxHeight: 220),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _filteredSpots.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(Icons.search_off, color: Colors.grey),
                              SizedBox(width: 10),
                              Text(
                                'Lokasi tidak ditemukan',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: _filteredSpots.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final spot = _filteredSpots[index];
                            return ListTile(
                              dense: true,
                              leading: CircleAvatar(
                                radius: 16,
                                backgroundColor:
                                    spot.color.withValues(alpha: 0.15),
                                child: Icon(
                                  spot.icon,
                                  size: 18,
                                  color: spot.color,
                                ),
                              ),
                              title: Text(
                                spot.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${spot.category} • ${spot.address}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () => _focusToSpot(spot),
                            );
                          },
                        ),
                )
              else ...[
                // Pintasan Lokasi Horizontal saat tidak sedang mengetik pencarian
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: bandungLocations.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final spot = bandungLocations[index];
                      final isSelected = _selectedSpot?.id == spot.id;
                      return ActionChip(
                        avatar: Icon(
                          spot.icon,
                          size: 16,
                          color: isSelected ? Colors.white : spot.color,
                        ),
                        label: Text(
                          spot.name,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: isSelected ? spot.color : Colors.white,
                        elevation: 2,
                        onPressed: () => _focusToSpot(spot),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),

        // Tombol Kontrol Peta (Zoom In, Zoom Out, Reset)
        Positioned(
          bottom: 20,
          right: 16,
          child: Column(
            children: [
              FloatingActionButton.small(
                heroTag: 'zoom_in',
                onPressed: _zoomIn,
                backgroundColor: Colors.white,
                child: const Icon(Icons.add, color: Color(0xFF1E3A8A)),
              ),
              const SizedBox(height: 8),
              FloatingActionButton.small(
                heroTag: 'zoom_out',
                onPressed: _zoomOut,
                backgroundColor: Colors.white,
                child: const Icon(Icons.remove, color: Color(0xFF1E3A8A)),
              ),
              const SizedBox(height: 8),
              FloatingActionButton.small(
                heroTag: 'reset_center',
                onPressed: _resetCenter,
                backgroundColor: const Color(0xFF1E3A8A),
                child: const Icon(Icons.my_location, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}