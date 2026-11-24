import 'package:flutter/material.dart';
import '../models/app_data.dart';

class InfoGridScreen extends StatelessWidget {
  final Function(SpotLocation) onViewOnMap;

  const InfoGridScreen({super.key, required this.onViewOnMap});

  void _showDetailDialog(BuildContext context, SpotLocation spot) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        titlePadding: EdgeInsets.zero,
        title: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: SizedBox(
            height: 150,
            width: double.infinity,
            child: Image.asset(
              spot.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: spot.color.withValues(alpha: 0.15),
                child: Icon(spot.icon, size: 54, color: spot.color),
              ),
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              spot.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Chip(
              label: Text('${spot.category} • ⭐ ${spot.rating}'),
              backgroundColor: spot.color.withValues(alpha: 0.12),
            ),
            const SizedBox(height: 8),
            Text(
              spot.address,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(spot.description),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              onViewOnMap(spot);
            },
            icon: const Icon(Icons.map, size: 18),
            label: const Text('Lihat di Peta'),
            style: ElevatedButton.styleFrom(
              backgroundColor: spot.color,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: GridView.builder(
        itemCount: bandungLocations.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.74,
        ),
        itemBuilder: (context, index) {
          final spot = bandungLocations[index];
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _showDetailDialog(context, spot),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 105,
                    width: double.infinity,
                    child: Image.asset(
                      spot.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: spot.color.withValues(alpha: 0.15),
                          child: Center(
                            child: Icon(
                              spot.icon,
                              size: 40,
                              color: spot.color,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            spot.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            spot.category,
                            style: TextStyle(
                              fontSize: 12,
                              color: spot.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    spot.rating.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}